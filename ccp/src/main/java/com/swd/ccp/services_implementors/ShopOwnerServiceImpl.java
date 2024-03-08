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
                                .name(manager.getAccount().getName())
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
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getName));
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
                staffList.sort(Comparator.comparing(StaffListResponse.StaffResponse::getName).reversed());
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
                                        .name(staff.getAccount().getUsername())
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
        //---------------------------------------------------------------------------------
        //
        // concept: add 1 area or 1 seat per time, if create new area then followed add 1
        //          new table
        // requirement: send a request
        // problems:
        //      -- if id = -1 then create new area, else create new table in existed table
        //      -- area's name or table's name duplicated to the current active area or table
        //      -- when id != 1 then the id must belong to shop's active area list
        //
        //---------------------------------------------------------------------------------
        Manager owner;
        if((owner = checkIfOwner()) != null){
            // if id = -1 => create new area and a table inside
            if(request.getId() == -1){
                return createNewAreaAndTable(request, owner.getShop());
            }

            // if id > 0 => create table inside existed area
            return createNewTableInExistedArea(request, owner.getShop());
        }
        return CreateAreaResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .build();
    }

    private CreateAreaResponse createNewAreaAndTable(CreateAreaRequest request, Shop shop){
        // check if area name is existed in shop or not
        List<Area> areas = getActiveAreaListInShop(shop);
        for(Area area: areas){
            // if already existed then return false
            if(request.getName().equals(area.getName())) {
                return CreateAreaResponse.builder()
                        .status(false)
                        .message("Area " + request.getName() + " is already existed in shop")
                        .area(null)
                        .build();
            }
        }
        // not yet existed name
        // check if table name is existed in shop or not
        // if not then create new table
        if(checkIfSeatNameNotExistedInShop(request.getSeatName(), shop)){
            return getCreateAreaResponse(request, createNewArea(request, shop));
        }
        return CreateAreaResponse.builder()
                .status(false)
                .message("Table " + request.getSeatName() + " is already existed in shop")
                .area(null)
                .build();
    }

    private Area createNewArea(CreateAreaRequest request, Shop shop){
        AreaStatus active = areaStatusRepo.findByStatus("active");
        return Area.builder()
                        .name(request.getName())
                        .shop(shop)
                        .areaStatus(active)
                        .build();
    }

    private Seat createNewTable(CreateAreaRequest request, Area area){
        SeatStatus available = seatStatusRepo.findByStatus("available");
        area = areaRepo.save(area);
        return seatRepo.save(
                Seat.builder()
                        .area(area)
                        .seatStatus(available)
                        .name(request.getSeatName())
                        .capacity(request.getSeatCapacity())
                        .build()
        );
    }

    private CreateAreaResponse createNewTableInExistedArea(CreateAreaRequest request, Shop shop){
        // find if area belongs to shop
        for(Area area: getActiveAreaListInShop(shop)){
            //if existed and be active then allow to move to the next step
            if(area.getId().equals(request.getId())){
                // check if table name is existed in shop or not
                // if not yet existed then allow to create new
                if(checkIfSeatNameNotExistedInShop(request.getSeatName(), shop)){
                    return getCreateAreaResponse(request, area);
                }
                // if existed then return fail
                return CreateAreaResponse.builder()
                        .status(false)
                        .message("Table with name " + request.getSeatName() + " is already existed in shop")
                        .area(null)
                        .build();
            }
        }
        // if not existed then return fail
        return CreateAreaResponse.builder()
                .status(false)
                .message("Area with id " + request.getId() + " is not existed in shop")
                .area(null)
                .build();
    }

    private CreateAreaResponse getCreateAreaResponse(CreateAreaRequest request, Area area) {
        Seat newTable = createNewTable(request, area);
        return CreateAreaResponse.builder()
                .status(true)
                .message("Table " + request.getSeatName() + " has been successfully created")
                .area(
                        CreateAreaResponse.AreaResponse.builder()
                                .id(area.getId())
                                .name(area.getName())
                                .status(area.getAreaStatus().getStatus())
                                .seat(
                                        CreateAreaResponse.SeatResponse.builder()
                                                .id(newTable.getId())
                                                .name(newTable.getName())
                                                .capacity(newTable.getCapacity())
                                                .status(newTable.getSeatStatus().getStatus())
                                                .build()
                                )
                                .build()
                )
                .build();
    }

    private List<Area> getActiveAreaListInShop(Shop shop){
        List<Area> areas = new ArrayList<>();
        for(Area area: shop.getAreaList()){
            if(area.getAreaStatus().getStatus().equals("active")){
                areas.add(area);
            }
        }
        return areas;
    }

    private List<Seat> getActiveSeatListInShop(List<Area> areas){
        List<Seat> seats = new ArrayList<>();
        for(Area area: areas){
            for(Seat seat: area.getSeatList()){
                if(seat.getSeatStatus().getStatus().equals("available")){
                    seats.add(seat);
                }
            }

        }
        return seats;
    }

    private boolean checkIfSeatNameNotExistedInShop(String seatName, Shop shop){
        for(Seat s: getActiveSeatListInShop(getActiveAreaListInShop(shop))){
            if(s.getName().equals(seatName)) return false;
        }
        return true;
    }

    @Override
    public DeleteAreaResponse deleteArea(DeleteAreaRequest request) {
        //---------------------------------------------------------------------------------
        //
        // concept: delete multi-tables per time, if delete all then auto delete area
        // requirement: send list of seat id
        // problems:
        //      -- seat id is not existed in list of active seats in area
        //
        //---------------------------------------------------------------------------------

        Manager owner;
        if((owner = checkIfOwner()) != null){
            // Get active area list and available seat list
            List<Area> areas = getActiveAreaListInShop(owner.getShop());
            List<Seat> seats = getActiveSeatListInShop(areas);
            return deleteTables(request, areas, seats);

        }
        return DeleteAreaResponse.builder()
                .status(false)
                .message("This account doesn't have enough permission to use this feature")
                .build();
    }

    @Override
    public void createShopOwnerAccount(Account account, Shop shop) {
        managerRepo.save(
                Manager.builder()
                        .account(account)
                        .shop(shop)
                        .build()
        );
    }

    private DeleteAreaResponse deleteTables(DeleteAreaRequest request, List<Area> activeAreas, List<Seat> activeSeats){
        List<Integer> sampleIdList = new ArrayList<>();
        SeatStatus seatStatus = seatStatusRepo.findByStatus("unavailable");
        for(Seat seat: activeSeats){
            sampleIdList.add(seat.getId());
        }

        // Check if all id input is valid
        for(DeleteAreaRequest.SeatRequest seatRequest: request.getSeatList()){
            if(!sampleIdList.contains(seatRequest.getId())){
                return DeleteAreaResponse.builder()
                        .status(false)
                        .message("Seat with id " + seatRequest.getId() + " is not existed in shop")
                        .build();
            }
        }

        // Take all seat has id included in delete id list
        for(Seat seat: activeSeats){
            if(request.getSeatList().contains(new DeleteAreaRequest.SeatRequest(seat.getId()))){
                seat.setSeatStatus(seatStatus);
                seatRepo.save(seat);
            }
        }

        deleteAreaWhenNoMoreAvailableSeat(activeAreas);
        return DeleteAreaResponse.builder()
                .status(true)
                .message("Delete " + request.getSeatList().size() + " table(s) successfully")
                .build();
    }

    private void deleteAreaWhenNoMoreAvailableSeat(List<Area> activeAreas){
        int activeSeat = 0;
        AreaStatus areaStatus = areaStatusRepo.findByStatus("inactive");
        for(Area area: activeAreas){
            for(Seat seat: area.getSeatList()){
                if(seat.getSeatStatus().getStatus().equals("available")){
                    activeSeat++;
                }
            }
            if(activeSeat == 0){
                area.setAreaStatus(areaStatus);
                areaRepo.save(area);
            }
        }
    }
}
