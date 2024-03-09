package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.Area;
import com.swd.ccp.models.entity_models.Cat;
import com.swd.ccp.models.entity_models.Manager;
import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.request_models.CreateCatRequest;
import com.swd.ccp.models.request_models.DeleteCatRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.repositories.AreaRepo;
import com.swd.ccp.repositories.CatRepo;
import com.swd.ccp.repositories.CatStatusRepo;
import com.swd.ccp.repositories.ManagerRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.CatService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CatServiceImpl implements CatService {

    private final ManagerRepo managerRepo;
    private final AccountService accountService;
    private final CatRepo catRepo;
    private final CatStatusRepo catStatusRepo;
    private final AreaRepo areaRepo;


    private List<Cat> getAvailableCatList(){
        List<Cat> cats = new ArrayList<>();
        for(Area area: getShop().getAreaList()){
            for(Cat cat: area.getCatList()){
                if(cat.getCatStatus().getStatus().equals("available")){
                    cats.add(cat);
                }
            }
        }
        return cats;
    }

    private Shop getShop(){
        Manager owner = managerRepo.findByAccount(accountService.getCurrentLoggedUser()).orElse(null);
        assert owner != null;
        return owner.getShop();
    }

    @Override
    public CatShopListResponse getCatList() {
        List<CatShopListResponse.AreaResponse> areas = new ArrayList<>();

        for(Area area: getShop().getAreaList()){
            List<CatShopListResponse.CatResponse> cats = new ArrayList<>();
            for(Cat cat: area.getCatList()){
                if(cat.getCatStatus().getStatus().equals("available")){
                    cats.add(
                            CatShopListResponse.CatResponse.builder()
                                    .id(cat.getId())
                                    .name(cat.getName())
                                    .type(cat.getType())
                                    .description(cat.getDescription())
                                    .imgLink(cat.getImgLink())
                                    .build()
                    );
                }
            }

            areas.add(
                    CatShopListResponse.AreaResponse.builder()
                            .areaId(area.getId())
                            .areaName(area.getName())
                            .cat(cats)
                            .build()
            );
        }

        return CatShopListResponse.builder()
                .status(true)
                .message("")
                .area(areas)
                .build();
    }

    @Override
    public CreateCatResponse createCat(CreateCatRequest request) {
        List<Cat> cats = getAvailableCatList();
        for (Cat cat: cats){
            if(cat.getName().equals(request.getName())){
                return CreateCatResponse.builder()
                        .status(false)
                        .message("Cat with name " + request.getName() + " is currently existed")
                        .build();
            }
        }
        Area area = areaRepo.findByNameAndShop(request.getAreaName(), getShop()).orElse(null);
        if(area != null){
            catRepo.save(
                    Cat.builder()
                            .name(request.getName())
                            .area(area)
                            .catStatus(catStatusRepo.findByStatus("available"))
                            .type(request.getType())
                            .description(request.getDescription())
                            .imgLink(request.getImgLink())
                            .build()
            );
            return CreateCatResponse.builder()
                    .status(true)
                    .message("Create cat successfully")
                    .build();
        }
        return CreateCatResponse.builder()
                .status(false)
                .message("Area with name " + request.getAreaName() + " is not existed")
                .build();
    }

    @Override
    public DeleteCatResponse deleteCat(DeleteCatRequest request) {
        List<Cat> cats = getAvailableCatList();
        List<DeleteCatRequest.CatRequest> catIdList = cats.stream().map(cat -> new DeleteCatRequest.CatRequest(cat.getId())).toList();
        for(DeleteCatRequest.CatRequest id: request.getListCatId()){
            if(!catIdList.contains(id)){
                return DeleteCatResponse.builder()
                        .status(false)
                        .message("Cat with id " + id.getCatId() + " does not belong to this shop")
                        .build();
            }
        }

        for(Cat cat: cats){
            if(request.getListCatId().contains(new DeleteCatRequest.CatRequest(cat.getId()))){
                cat.setCatStatus(catStatusRepo.findByStatus("unavailable"));
                catRepo.save(cat);
            }
        }
        return DeleteCatResponse.builder()
                .status(true)
                .message("Delete " + request.getListCatId().size() + " cat(s) successfully")
                .build();
    }
}
