package com.swd.ccp.services_implementors;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.*;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.ShopOwnerService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class ShopOwnerServiceImpl implements ShopOwnerService {
    private final AccountRepo accountRepo;
    private final AccountStatusRepo accountStatusRepo;
    private final ManagerRepo managerRepo;
    private final AccountService accountService;
    private final SeatStatusRepo seatStatusRepo;
    private final AreaStatusRepo areaStatusRepo;
    private final AreaRepo areaRepo;
    private final SeatRepo seatRepo;
    private final PasswordEncoder passwordEncoder;


    private Manager checkIfOwner(){
        Account account = accountService.getCurrentLoggedUser();
        return managerRepo.findByAccount(account).orElse(null);
    }
    @Override
    public StaffListResponse getStaffList(SortStaffListRequest request) {
        Manager owner;
        if((owner = checkIfOwner()) != null){
            // get manager list
            List<Manager> managerList = owner.getShop().getManagerList();
            List<StaffListResponse.StaffResponse> staffList = new ArrayList<>();

            // remove manager out of list
            for(Manager manager: managerList){
                staffList.add(
                        StaffListResponse.StaffResponse.builder()
                                .id(manager.getId())
                                .email(manager.getAccount().getEmail())
                                .username(manager.getAccount().getName())
                                .phone(manager.getAccount().getPhone())
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
        Manager owner;
        if((owner = checkIfOwner()) != null){
            Account acc = accountRepo.findByEmail(request.getEmail()).orElse(null);
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

    @Override
    public UpdateStaffResponse updateStaff(UpdateStaffRequest request) {
        Manager owner;
        if((owner = checkIfOwner()) != null){
            Manager staff = managerRepo.findById(request.getStaffId()).orElse(null);
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
    public ChangeStatusStaffResponse changeStatusStaff(ChangeStatusStaffRequest request, String type) {
        Manager owner;
        if((owner = checkIfOwner()) != null){
            Manager staff = managerRepo.findById(request.getStaffId()).orElse(null);

            if(staff != null && owner.getShop().getManagerList().contains(staff)){
                String newStatus = "active";
                if(type.equals("ban")) newStatus = "inactive";

                if(!staff.getAccount().getStatus().getStatus().equals(newStatus)){
                    AccountStatus accountStatus = accountStatusRepo.findByStatus(newStatus);
                    staff.getAccount().setStatus(accountStatus);
                    managerRepo.save(staff);

                    return ChangeStatusStaffResponse.builder()
                            .status(true)
                            .message("This account is now been " + newStatus)
                            .staffResponse(
                                    ChangeStatusStaffResponse.StaffResponse.builder()
                                            .id(staff.getId())
                                            .status(staff.getAccount().getStatus().getStatus())
                                            .build()
                            )
                            .build();
                }
                return ChangeStatusStaffResponse.builder()
                        .status(false)
                        .message("This account is already " + newStatus)
                        .staffResponse(null)
                        .build();
            }
        }

        return ChangeStatusStaffResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .staffResponse(null)
                .build();
    }

    @Override
    public UpdateShopResponse updateShop(UpdateShopRequest request) {
        Manager owner;
        if((owner = checkIfOwner()) != null){

            Shop shop = owner.getShop();
            shop.setName(request.getName());
            shop.setAddress(request.getAddress());
            shop.setOpenTime(request.getOpenTime());
            shop.setCloseTime(request.getCloseTime());
            shop.setPhone(request.getPhone());
            shop.setAvatar(request.getAvatar());
            owner.setShop(shop);
            managerRepo.save(owner);

            return UpdateShopResponse.builder()
                    .status(true)
                    .message("")
                    .response(
                            UpdateShopResponse.ShopResponse.builder()
                                    .name(shop.getName())
                                    .address(shop.getAddress())
                                    .openTime(shop.getOpenTime())
                                    .closeTime(shop.getCloseTime())
                                    .phone(shop.getPhone())
                                    .avatar(shop.getAvatar())
                                    .build()
                    )
                    .build();
        }

        return UpdateShopResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .response(null)
                .build();
    }

    @Override
    public CreateAreaResponse createAreaAndTable(CreateAreaRequest request) {
        Manager owner;
        if((owner = checkIfOwner()) != null){
            AreaStatus areaStatus = areaStatusRepo.findByStatus("active").orElse(null);
            SeatStatus seatStatus = seatStatusRepo.findByStatus("available").orElse(null);
            assert areaStatus != null;
            assert seatStatus != null;

            // Create new area
            if(request.getId() < 1){
                if(areaRepo.findByNameAndShop(request.getName(), owner.getShop()).orElse(null) == null){
                    // Create area
                    Area area = areaRepo.save(
                            Area.builder()
                                    .name(request.getName())
                                    .shop(owner.getShop())
                                    .areaStatus(areaStatus)
                                    .build()
                    );

                    // Create table
                    List<CreateAreaResponse.SeatResponse> seatResponses = new ArrayList<>();
                    for(CreateAreaRequest.SeatResponse seatResponse: request.getSeatList()){
                        Seat newSeat = seatRepo.save(Seat.builder()
                                .area(area)
                                .seatStatus(seatStatus)
                                .name(seatResponse.getName())
                                .capacity(seatResponse.getCapacity())
                                .build());

                        seatResponses.add(
                                CreateAreaResponse.SeatResponse.builder()
                                        .id(newSeat.getId())
                                        .name(newSeat.getName())
                                        .capacity(newSeat.getCapacity())
                                        .status(seatStatus.getStatus())
                                        .build()
                        );

                        return CreateAreaResponse.builder()
                                .status(true)
                                .message("Successfully create area")
                                .area(
                                        CreateAreaResponse.AreaResponse.builder()
                                                .id(area.getId())
                                                .name(area.getName())
                                                .status(areaStatus.getStatus())
                                                .seatList(seatResponses)
                                                .build()
                                )
                                .build();
                    }
                }

                return CreateAreaResponse.builder()
                        .status(false)
                        .message("Area is already existed")
                        .area(null)
                        .build();
            }
            // Create tables in area
            Area existedArea = areaRepo.findById(request.getId()).orElse(null);
            List<CreateAreaResponse.SeatResponse> seatResponseList = new ArrayList<>();
            if(existedArea != null){
                for(CreateAreaRequest.SeatResponse seatResponse: request.getSeatList()){
                    if(seatRepo.findByNameAndArea(seatResponse.getName(), existedArea).orElse(null) == null){
                        Seat newSeat = seatRepo.save(Seat.builder()
                                .area(existedArea)
                                .seatStatus(seatStatus)
                                .name(seatResponse.getName())
                                .capacity(seatResponse.getCapacity())
                                .build());

                        seatResponseList.add(
                                CreateAreaResponse.SeatResponse.builder()
                                        .id(newSeat.getId())
                                        .name(newSeat.getName())
                                        .capacity(newSeat.getCapacity())
                                        .status(seatStatus.getStatus())
                                        .build()
                        );

                        return CreateAreaResponse.builder()
                                .status(true)
                                .message("Successfully create " + request.getSeatList().size() + " tables")
                                .area(
                                        CreateAreaResponse.AreaResponse.builder()
                                                .id(existedArea.getId())
                                                .name(existedArea.getName())
                                                .status(areaStatus.getStatus())
                                                .seatList(seatResponseList)
                                                .build()
                                )
                                .build();
                    }

                    return CreateAreaResponse.builder()
                            .status(false)
                            .message("Table is already existed")
                            .area(null)
                            .build();
                }
            }
            return CreateAreaResponse.builder()
                    .status(false)
                    .message("Area is not existed")
                    .area(null)
                    .build();
        }

        return CreateAreaResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .area(null)
                .build();
    }

    @Override
    public DeleteAreaResponse deleteArea(DeleteAreaRequest request) {
        Manager owner;
        if((owner = checkIfOwner()) != null){
            List<Area> areaList = owner.getShop().getAreaList();
            Area area = areaRepo.findById(request.getId()).orElse(null);
            if(area != null){
                if(areaList.contains(area)){
                    List<Seat> seatList = area.getSeatList();
                    // If no table then delete the area
                    int deletedCount = 0;
                    // If at least 1 table then delete it
                    SeatStatus deleteSeatStatus = seatStatusRepo.findByStatus("unavailable").orElse(null);
                    assert deleteSeatStatus != null;
                    for(Seat seat: area.getSeatList()){
                        if(request.getSeatList().contains(new DeleteAreaRequest.SeatRequest(seat.getId()))){
                            seat.setSeatStatus(deleteSeatStatus);
                            deletedCount++;
                        }
                    }
                    areaRepo.save(area);

                    if(deletedCount == 0){
                        return DeleteAreaResponse.builder()
                                .status(false)
                                .message("Table(s) not found")
                                .build();
                    }

                    int numOfNonAvailableSeat = 0;
                    for(Seat seat: seatList){
                        if(seat.getSeatStatus().getStatus().equals("unavailable")){
                            numOfNonAvailableSeat++;
                        }
                    }
                    if(numOfNonAvailableSeat == seatList.size()){
                        AreaStatus deleteAreaStatus = areaStatusRepo.findByStatus("inactive").orElse(null);
                        assert deleteAreaStatus != null;
                        area.setAreaStatus(deleteAreaStatus);
                        areaRepo.save(area);

                        return DeleteAreaResponse.builder()
                                .status(true)
                                .message("Delete " + area.getName() + " successfully")
                                .build();
                    }

                    return DeleteAreaResponse.builder()
                            .status(true)
                            .message("Delete " + deletedCount + " table(s) successfully")
                            .build();
                }
                return DeleteAreaResponse.builder()
                        .status(false)
                        .message("Area with id " + request.getId() + " is not found")
                        .build();
            }
            return DeleteAreaResponse.builder()
                    .status(false)
                    .message("Area with id " + request.getId() + " is not existed")
                    .build();
        }
        return DeleteAreaResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .build();
    }

}
