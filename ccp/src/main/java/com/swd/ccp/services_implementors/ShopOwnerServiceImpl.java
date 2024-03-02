package com.swd.ccp.services_implementors;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.request_models.CreateStaffRequest;
import com.swd.ccp.models.request_models.UpdateStaffRequest;
import com.swd.ccp.models.response_models.CreateStaffResponse;
import com.swd.ccp.models.response_models.StaffListResponse;
import com.swd.ccp.models.response_models.UpdateStaffResponse;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.JWTService;
import com.swd.ccp.services.ShopOwnerService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

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
    public StaffListResponse getStaffList(SortStaffListRequest request) {
        Account account = accountService.getCurrentLoggedUser();
        if(account.getRole().equals(Role.OWNER)){
            Manager owner = managerRepo.findByAccount(account).orElse(null);
            assert owner != null;
            // get manager list
            List<Manager> managerList = owner.getShop().getManagerList();
            List<StaffListResponse.StaffResponse> staffList = new ArrayList<>();

            // remove manager out of list
            for(Manager manager: managerList){
                staffList.add(
                        StaffListResponse.StaffResponse.builder()
                                .id(manager.getId())
                                .email(manager.getAccount().getEmail())
                                .username(manager.getAccount().getUsername())
                                .status(manager.getAccount().getStatus().getStatus())
                                .build()
                );
            }

            for(StaffListResponse.StaffResponse response: staffList){
                Manager manager = managerRepo.findById(response.getId()).orElse(null);
                if(manager != null && manager.getAccount().getRole().equals(Role.OWNER)){
                    staffList.remove(response);
                    break;
                }
            }

            // sort
            if(request.isAscOrder()){
                sortAsc(staffList, request.getColumn());
            }else {
                sortDesc(staffList, request.getColumn());
            }

            return StaffListResponse.builder()
                    .status(true)
                    .message("")
                    .staffList(staffList)
                    .build();
        }
        return StaffListResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .staffList(Collections.emptyList())
                .build();
    }

    private void sortAsc(List<StaffListResponse.StaffResponse> staffList, String column){
        switch (column){
            case "id":
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getId));
                break;
            case "email":
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getEmail));
                break;
            case "username":
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getUsername));
                break;
            case "status":
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getStatus));
                break;

        }
    }

    private void sortDesc(List<StaffListResponse.StaffResponse> staffList, String column){
        switch (column){
            case "id":
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getId).reversed());
                break;
            case "email":
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getEmail).reversed());
                break;
            case "username":
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getUsername).reversed());
                break;
            case "status":
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getStatus).reversed());
                break;

        }
    }

    @Override
    public CreateStaffResponse createStaff(CreateStaffRequest request) {
        Account account = accountService.getCurrentLoggedUser();
        if(account.getRole().equals(Role.OWNER)){
            Manager owner = managerRepo.findByAccount(account).orElse(null);
            Account acc = accountRepo.findByEmail(request.getEmail()).orElse(null);
            assert owner != null;
            if(acc == null){
                acc = Account.builder()
                        .email(request.getEmail())
                        .name(request.getName())
                        .password(passwordEncoder.encode(request.getPassword()))
                        .phone(request.getPhone())
                        .status(accountStatusRepo.findByStatus("active"))
                        .role(Role.STAFF)
                        .build();
                accountRepo.save(acc);

                Manager staff = managerRepo.save(Manager.builder().account(acc).shop(owner.getShop()).build());

                return CreateStaffResponse.builder()
                        .status(true)
                        .message("Create staff account for " + request.getEmail() + " successfully")
                        .staffResponse(
                                CreateStaffResponse.StaffResponse.builder()
                                        .id(staff.getId())
                                        .email(staff.getAccount().getEmail())
                                        .username(staff.getAccount().getUsername())
                                        .phone(staff.getAccount().getPhone())
                                        .status(staff.getAccount().getStatus().getStatus())
                                        .build()
                        )
                        .build();
            }
            return CreateStaffResponse.builder()
                    .status(false)
                    .message("This account is already existed")
                    .staffResponse(null)
                    .build();
        }
        return CreateStaffResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .staffResponse(null)
                .build();
    }

    private boolean isStringValid(String string) {
        return string != null && !string.isEmpty();
    }
    @Override
    public UpdateStaffResponse updateStaff(UpdateStaffRequest request) {
        Account account = accountService.getCurrentLoggedUser();
        if(account.getRole().equals(Role.OWNER)){
            Manager owner = managerRepo.findByAccount(account).orElse(null);
            Manager staff = managerRepo.findById(request.getStaffId()).orElse(null);
            assert owner != null;
            if(staff != null){
                List<Manager> managerList = owner.getShop().getManagerList();
                if(managerList.contains(staff)){
                    Account staffAccount = staff.getAccount();
                    staffAccount.setEmail(request.getEmail());
                    staffAccount.setName(request.getName());
                    staffAccount.setPassword(passwordEncoder.encode(request.getPassword()));
                    staffAccount.setPhone(request.getPhone());
                    staff.setAccount(staffAccount);

                    //staffAccount = accountRepo.save(staffAccount);
                    staff = managerRepo.save(staff);
                }

                return UpdateStaffResponse.builder()
                        .status(true)
                        .message("Update staff with id " + request.getStaffId() + " successfully")
                        .staffResponse(
                                UpdateStaffResponse.StaffResponse.builder()
                                        .id(staff.getId())
                                        .username(staff.getAccount().getUsername())
                                        .email(staff.getAccount().getEmail())
                                        .phone(staff.getAccount().getPhone())
                                        .status(staff.getAccount().getStatus().getStatus())
                                        .build()
                        )
                        .build();
            }
            return UpdateStaffResponse.builder()
                    .status(false)
                    .message("Staff with id " + request.getStaffId() + " is not existed")
                    .staffResponse(null)
                    .build();
        }
        return UpdateStaffResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .staffResponse(null)
                .build();
    }
    @Override
    public int inactiveStaff(Integer staffId) {
        return 0;
    }
    @Override
    public int activeStaff(Integer staffId) {
        return 0;
    }
}
