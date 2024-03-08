package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.CreateMenuItemRequest;
import com.swd.ccp.models.request_models.DeleteMenuItemRequest;
import com.swd.ccp.models.request_models.UpdateMenuItemRequest;
import com.swd.ccp.models.response_models.CreateMenuItemResponse;
import com.swd.ccp.models.response_models.DeleteMenuItemResponse;
import com.swd.ccp.models.response_models.MenuItemListResponse;
import com.swd.ccp.models.response_models.UpdateMenuItemResponse;
import com.swd.ccp.repositories.ManagerRepo;
import com.swd.ccp.repositories.MenuItemRepo;
import com.swd.ccp.repositories.MenuItemStatusRepo;
import com.swd.ccp.repositories.MenuRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MenuServiceImpl implements MenuService {

    private final AccountService accountService;
    private final ManagerRepo managerRepo;
    private final MenuRepo menuRepo;
    private final MenuItemRepo menuItemRepo;
    private final MenuItemStatusRepo menuItemStatusRepo;

    private Manager convertToOwner(){
        Account account = accountService.getCurrentLoggedUser();
        return managerRepo.findByAccount(account).orElse(null);
    }
    @Override
    public MenuItemListResponse getMenuItemList() {
        Manager owner = convertToOwner();
        if(owner != null){
            Menu menu = menuRepo.findByShop(owner.getShop()).orElse(null);
            assert menu != null;
            List<MenuItem> items = menuItemRepo.findByMenu(menu);
            List<MenuItemListResponse.MenuItemResponse> itemList = new ArrayList<>();
            for(MenuItem item: items){
                if(item.getMenuItemStatus().getStatus().equals("available")){
                    itemList.add(
                            MenuItemListResponse.MenuItemResponse.builder()
                                    .id(item.getId())
                                    .name(item.getName())
                                    .price(item.getPrice())
                                    .status(item.getMenuItemStatus().getStatus())
                                    .description(item.getDescription())
                                    .soldQuantity(item.getSoldQuantity())
                                    .build()
                    );
                }
            }
            return MenuItemListResponse.builder()
                    .status(true)
                    .message("")
                    .itemList(itemList)
                    .build();
        }
        return MenuItemListResponse.builder()
                .status(false)
                .message("Account has no permission")
                .itemList(Collections.emptyList())
                .build();
    }

    @Override
    public CreateMenuItemResponse createMenuItem(CreateMenuItemRequest request) {
        //---------------------------------------------------------------------------------
        //
        // concept: create 1 item per time
        // requirement: list item {name, price, imgLink, description,
        //              discount: default 0, soldQuantity: default 0} (menu item)
        // problems:
        //      -- Name can not duplicated with available ones
        //
        // steps:
        //      -- Create a menu as default
        //      --
        //      --
        //---------------------------------------------------------------------------------

        Manager owner = convertToOwner();
        if(owner != null){
            return createNewMenuItem(request, owner.getShop());
        }
        return CreateMenuItemResponse.builder()
                .status(false)
                .message("Account has no permission")
                .build();
    }

    @Override
    public UpdateMenuItemResponse updateMenuItem(UpdateMenuItemRequest request) {
        Manager owner = convertToOwner();
        if(owner != null){
            return updateMenuItem(request, owner.getShop());
        }
        return UpdateMenuItemResponse.builder()
                .status(false)
                .message("Account has no permission")
                .build();
    }

    private CreateMenuItemResponse createNewMenuItem(CreateMenuItemRequest request, Shop shop){
        Menu menu = menuRepo.findByShop(shop).orElse(null);
        MenuItemStatus status = menuItemStatusRepo.findByStatus("available");
        assert menu != null;
        if(menuItemRepo.existsByNameAndMenu(request.getName(), menu)){
            return CreateMenuItemResponse.builder()
                    .status(false)
                    .message("This food is already existed")
                    .build();
        }

        MenuItem item = menuItemRepo.save(
                MenuItem.builder()
                        .menu(menu)
                        .menuItemStatus(status)
                        .name(request.getName())
                        .price(request.getPrice())
                        .imgLink("")
                        .description(request.getDescription())
                        .discount(0)
                        .soldQuantity(0)
                        .build()
        );
        return CreateMenuItemResponse.builder()
                .status(true)
                .message("Create " + item.getName() + " successfully")
                .build();
    }

    private UpdateMenuItemResponse updateMenuItem(UpdateMenuItemRequest request, Shop shop){
        Menu menu = menuRepo.findByShop(shop).orElse(null);
        assert menu != null;
        MenuItem item = menuItemRepo.findByIdAndMenu(request.getId(), menu).orElse(null);
        if(item != null){
            if(!(menuItemRepo.existsByNameAndMenu(request.getName(), menu) && !item.getName().equals(request.getName()))){
                item.setName(request.getName());
                item.setPrice(request.getPrice());
                item.setDescription(request.getDescription());
                menuItemRepo.save(item);
                return UpdateMenuItemResponse.builder()
                        .status(true)
                        .message("Item with id " + request.getId() + " has been updated successfully")
                        .build();
            }
            return UpdateMenuItemResponse.builder()
                    .status(false)
                    .message("Item with name " + request.getName() + " is already existed in menu")
                    .build();
        }
        return UpdateMenuItemResponse.builder()
                .status(false)
                .message("Item with id " + request.getId() + " is not existed in menu")
                .build();
    }

    @Override
    public DeleteMenuItemResponse deleteMenuItem(DeleteMenuItemRequest request) {
        //---------------------------------------------------------------------------------
        //
        // concept: delete 1 item per time
        // requirement:
        // problems:
        //      --
        //
        // steps:
        //      --
        //---------------------------------------------------------------------------------

        Manager owner = convertToOwner();
        MenuItemStatus status = menuItemStatusRepo.findByStatus("unavailable");
        assert owner != null;
        Menu menu = menuRepo.findByShop(owner.getShop()).orElse(null);
        assert menu != null;
        MenuItem item = menuItemRepo.findByIdAndMenu(request.getItemId(), menu).orElse(null);
        if(item != null && !item.getMenuItemStatus().equals(status)){
            item.setMenuItemStatus(status);
            menuItemRepo.save(item);
            return DeleteMenuItemResponse.builder()
                    .status(true)
                    .message("Item with id " + request.getItemId() + " is deleted successfully")
                    .build();
        }
        return DeleteMenuItemResponse.builder()
                .status(false)
                .message("Item with id " + request.getItemId() + " is not existed in menu")
                .build();
    }



}
