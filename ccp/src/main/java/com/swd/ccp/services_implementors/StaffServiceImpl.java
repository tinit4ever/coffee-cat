package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;

import com.swd.ccp.models.entity_models.AccountStatus;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.models.request_models.StaffRequest;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.CreateStaffResponse;
import com.swd.ccp.models.response_models.StaffResponse;
import com.swd.ccp.models.response_models.UpdateStaffResponse;
import com.swd.ccp.repositories.AccountRepo;
import com.swd.ccp.repositories.AccountStatusRepo;
import com.swd.ccp.repositories.CustomerRepo;
import com.swd.ccp.repositories.TokenRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.JWTService;
import com.swd.ccp.services.StaffService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@Service
@RequiredArgsConstructor
public class StaffServiceImpl implements StaffService {
    private final AccountRepo accountRepo;
    private final JWTService jwtService;

    private final AccountStatusRepo accountStatusRepo;


    private final AccountService accountService;

    private final TokenRepo tokenRepo;
    private static final String ACTIVE = "Active";
    private static final String INACTIVE = "InActive";

    @Override
    public Page<StaffResponse> getStaffList(PaginationRequest pageRequest) {

        Pageable pageable = PageRequest.of(
                pageRequest.getPageNo(),
                pageRequest.getPageSize(),
                Sort.by(pageRequest.getSort().isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
                        pageRequest.getSortByColumn())
        );

        Page<Account> staffList = accountRepo.findByRole(Role.STAFF, pageable);

        List<StaffResponse> staffDtoList = mapToStaffDtoList(staffList.getContent());

        return new PageImpl<>(staffDtoList, pageable, staffList.getTotalElements());
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
            staffResponse.setName(account.getName());
            staffResponse.setPassword(account.getPassword());
            staffResponse.setStatus(account.getStatus().getStatus());
            staffResponse.setSuccess(true);
            staffResponse.setToken(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()));
            if (account.getName() == null) {
                staffResponse.setName("N/A");
            }
            return staffResponse;
        }).collect(Collectors.toList());
    }

    @Override
    public CreateStaffResponse createStaff(StaffRequest request) {
        if (isStringValid(request.getEmail()) &&
                isStringValid(request.getPassword())) {
            Account account = accountRepo.findByEmail(request.getEmail()).orElse(null);

            if (account == null) {
                account = accountRepo.save(
                        Account.builder()
                                .email(request.getEmail())
                                .password(request.getPassword())
                                .name(request.getName())
                                .status(accountStatusRepo.findById(1).orElse(null)) // Chỉnh lại nếu cần thiết
                                .role(Role.STAFF)
                                .build()
                );

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
                                        .name(account.getName())
                                        .password(account.getPassword())
                                        .success(true)
                                        .token(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()))
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
    public UpdateStaffResponse updateStaff(Long staffId, StaffRequest updateRequest) {
        Optional<Account> optionalStaff = accountRepo.findById(staffId);
        if (optionalStaff.isPresent()) {
            Account staff = optionalStaff.get();
            if (updateRequest.getEmail() != null) {
                staff.setEmail(updateRequest.getEmail());
            }
            if (updateRequest.getName() != null) {
                staff.setName(updateRequest.getName());
            }
            accountRepo.save(staff);

            UpdateStaffResponse response = new UpdateStaffResponse();
            response.setStaffId(staffId);
            response.setMessage("Staff information updated successfully.");
            response.setSuccess(true);
            response.setToken(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()));

            return response;
        } else {
            throw new NotFoundException("Staff with id " + staffId + " not found.");
        }
    }
    @Override
    public int inactiveStaff(Long staffId) {
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
    public int activeStaff(Long staffId) {
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