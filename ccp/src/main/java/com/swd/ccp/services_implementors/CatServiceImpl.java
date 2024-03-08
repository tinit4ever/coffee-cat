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
        List<Cat> cats = getAvailableCatList();

        List<CatShopListResponse.CatResponse> catResponses = cats.stream()
                .map(
                        cat -> new CatShopListResponse.CatResponse(
                                cat.getId(),
                                cat.getName(),
                                cat.getArea().getId(),
                                cat.getArea().getName(),
                                cat.getType(),
                                cat.getDescription(),
                                cat.getImgLink())
                )
                .toList();

        return CatShopListResponse.builder()
                .status(true)
                .message("")
                .cat(catResponses)
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
        for(Cat cat: cats){
            if(cat.getId().equals(request.getCatId())){
                cat.setCatStatus(catStatusRepo.findByStatus("unavailable"));
                catRepo.save(cat);
                return DeleteCatResponse.builder()
                        .status(true)
                        .message("Delete cat successfully")
                        .build();
            }
        }
        return DeleteCatResponse.builder()
                .status(false)
                .message("This cat does not belong to this shop")
                .build();
    }
}
