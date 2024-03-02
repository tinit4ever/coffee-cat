package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.AccountStatus;
import com.swd.ccp.models.entity_models.Manager;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.request_models.StaffRequest;
import com.swd.ccp.models.response_models.CreateStaffResponse;
import com.swd.ccp.models.response_models.StaffListResponse;
import com.swd.ccp.models.response_models.StaffResponse;
import com.swd.ccp.models.response_models.UpdateStaffResponse;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.JWTService;
import com.swd.ccp.services.ShopOwnerService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@Service
@RequiredArgsConstructor
public class ShopOwnerServiceImpl implements ShopOwnerService {
    private final AccountRepo accountRepo;
    private final JWTService jwtService;
    private final AccountStatusRepo accountStatusRepo;
    private final ManagerRepo managerRepo;
    private final AccountService accountService;
    private final ShopRepo shopRepo;
    private final TokenRepo tokenRepo;
    private final PasswordEncoder passwordEncoder;
    @Override
    public StaffListResponse getStaffList(SortRequest sortRequest) {
        Manager manager = managerRepo.findByAccount(accountService.getCurrentLoggedUser()).orElse(null);
        if(manager != null){
            Sort.Direction sortDirection = sortRequest.isAsc() ? Sort.Direction.ASC : Sort.Direction.DESC;
            Sort sort = Sort.by(sortDirection, sortRequest.getSortByColumn());
            List<Account> staffList = accountRepo.findAccountByShopIdAndRole(manager.getShop().getId(), Role.STAFF, sort);
            List<StaffResponse> mappedshopList = mapToStaffDtoList(staffList);

            return  StaffListResponse.builder()
                    .staffList(mappedshopList)
                    .status(true)
                    .message("Successfully retrieved staff list")
                    .build();
        }
        return  StaffListResponse.builder()
                .staffList(Collections.emptyList())
                .status(false)
                .message("Fail retrieved staff list")
                .build();
    }


    private List<StaffResponse> mapToStaffDtoList(List<Account> accounts) {
        if (accounts == null) {
            throw new IllegalArgumentException("Argument cannot be null");
        }

        if (accounts.isEmpty()) {
            return Collections.emptyList();
        }

        return accounts.stream().map(account -> {
            StaffResponse staffResponse = new StaffResponse();
            staffResponse.setId(account.getId());
            staffResponse.setEmail(account.getEmail());
            staffResponse.setUsername(account.getName());
            staffResponse.setStatus(account.getStatus().getStatus());

            if (account.getName() == null) {
                staffResponse.setUsername("N/A");
            }
            return staffResponse;
        }).collect(Collectors.toList());
    }

    @Override
    public CreateStaffResponse createStaff(StaffRequest request) {
        if (isStringValid(request.getEmail()) && isStringValid(request.getPassword())) {
            Account account = accountRepo.findByEmail(request.getEmail()).orElse(null);

            if (account == null) {
                account = accountRepo.save(
                        Account.builder()
                                .email(request.getEmail())
                                .password(request.getPassword())
                                .name(request.getName())
                                .status(accountStatusRepo.findById(1).orElse(null))
                                .role(Role.STAFF)
                                .build()
                );

                // Lưu thông tin nhân viên vào bảng ShopManager
                Manager shopManager = Manager.builder()
                        .account(account)
                        .shop(shopRepo.findById(request.getShopId()).orElse(null)) // Lưu shopId
                        .build();
                managerRepo.save(shopManager);

                Token accessToken = tokenRepo.save(
                        Token.builder()
                                .token(jwtService.generateToken(account))
                                .type("access")
                                .status(1)
                                .build()
                );

                Token refreshToken = tokenRepo.save(
                        Token.builder()
                                .token(jwtService.generateRefreshToken(account))
                                .type("refresh")
                                .status(1)
                                .build()
                );

                return CreateStaffResponse.builder()
                        .message("Register successfully")
                        .status(true)
                        .access_token(accessToken.getToken())
                        .refresh_token(refreshToken.getToken())
                        .staffResponse(
                                StaffResponse.builder()
                                        .id(account.getId())
                                        .email(account.getEmail())
                                        .status(account.getStatus().getStatus())
                                        .username(account.getName())
                                        .build()
                        )
                        .build();
            }
            return CreateStaffResponse.builder()
                    .message("Register fail: account is already existed")
                    .status(false)
                    .access_token(null)
                    .refresh_token(null)
                    .staffResponse(null)
                    .build();
        }
        return CreateStaffResponse.builder()
                .message("Register fail: input null or empty")
                .status(false)
                .access_token(null)
                .refresh_token(null)
                .staffResponse(null)
                .build();
    }

    private boolean isStringValid(String string) {
        return string != null && !string.isEmpty();
    }
    @Override
    public UpdateStaffResponse updateStaff(Integer staffId, StaffRequest updateRequest) {
        Optional<Account> optionalStaff = accountRepo.findById(staffId);
        if (optionalStaff.isPresent()) {
            Account staff = optionalStaff.get();
            if (updateRequest.getEmail() != null) {
                staff.setEmail(updateRequest.getEmail());
            }
            if (updateRequest.getName() != null) {
                staff.setName(updateRequest.getName());
            }
            if (updateRequest.getPassword() != null) {
                String encodedPassword = passwordEncoder.encode(updateRequest.getPassword());
                staff.setPassword(encodedPassword);
            }
            accountRepo.save(staff);

            UpdateStaffResponse response = new UpdateStaffResponse();
            response.setStaffId(staffId);
            response.setMessage("Staff information updated successfully.");
            response.setStatus(true);

            return response;
        } else {
            throw new NotFoundException("Staff with id " + staffId + " not found.");
        }
    }
    @Override
    public int inactiveStaff(Integer staffId) {
        if (staffId == null) return 0;

        try {
            Account account = accountRepo.findById(staffId).orElse(null);

            if(account == null) return 0;

            AccountStatus inactiveStatus = accountStatusRepo.findById(2).orElse(null);

            if (inactiveStatus == null) {
                throw new IllegalStateException("Inactive status not found.");
            }

            account.setStatus(inactiveStatus);

            accountRepo.save(account);

            LOGGER.info("Inactive successfully");

            return 1;
        } catch (Exception e) {
            LOGGER.error("Inactive failed");

            throw new IllegalStateException("Staff inactive failed", e);
        }
    }
    @Override
    public int activeStaff(Integer staffId) {
        if (staffId == null) return 0;

        try {
            Account account = accountRepo.findById(staffId).orElse(null);

            if(account == null) return 0;

            AccountStatus activeStatus = accountStatusRepo.findById(1).orElse(null);

            if (activeStatus == null) {
                throw new IllegalStateException("active status not found.");
            }

            account.setStatus(activeStatus);

            accountRepo.save(account);

            LOGGER.info("active successfully");

            return 1;
        } catch (Exception e) {
            LOGGER.error("active failed");

            throw new IllegalStateException("Staff active failed", e);
        }
    }
}