package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.entity_models.Cat;
import com.swd.ccp.models.entity_models.CatStatus;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.CatResponse;
import com.swd.ccp.repositories.CatRepo;
import com.swd.ccp.repositories.CatStatusRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.CatService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
@Service
@RequiredArgsConstructor

    public class CatServiceImpl implements CatService {
        private final CatStatusRepo catStatusRepo;
        private final CatRepo catRepo;
        private final AccountService accountService;
    private static final String ACTIVE = "Active";
        @Override

        public Page<CatResponse> getActiveCats(Integer shopId, PaginationRequest pageRequest) {
            List<CatStatus> activeStatusList = catStatusRepo.findAllByStatus(ACTIVE);

            if (activeStatusList.isEmpty()) {

                return Page.empty();
            }
            Pageable pageable = PageRequest.of(
                    pageRequest.getPageNo(),
                    pageRequest.getPageSize(),
                    Sort.by(pageRequest.getSort().isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
                            pageRequest.getSortByColumn())
            );

            Page<Cat> catList = catRepo.findAllByCatStatusIn(activeStatusList, pageable);

            List<CatResponse> catDtoList = mapToCatDtoList(catList.getContent(), shopId);


            return new PageImpl<>(catDtoList, pageable, catList.getTotalElements());
        }

        private List<CatResponse> mapToCatDtoList(List<Cat> cats, Integer shopId) {
            if (cats == null) {
                throw new IllegalArgumentException("Argument cannot be null");
            }

            if (cats.isEmpty()) {
                return Collections.emptyList();
            }

            return cats.stream()
                    .filter(cat -> cat.getShop().getId().equals(shopId)) // Lọc theo shopId
                    .map(cat -> {
                        CatResponse catResponse = new CatResponse();
                       catResponse.setDescription(cat.getDescription());
                       catResponse.setImgLink(cat.getDescription());
                       catResponse.setType(cat.getType());
                       catResponse.setSuccess(true);
                       catResponse.setToken(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()));

                        if (cat.getDescription() == null) {
                            catResponse.setDescription("N/A");
                        }
                        if (cat.getImgLink() == null) {
                            catResponse.setImgLink("N/A");
                        }
                        if (cat.getType() == null) {
                            catResponse.setType("N/A");
                        }
                        return catResponse;
                    }).collect(Collectors.toList());
        }
    @Override
    public CatResponse getCatDetails(Long id) {
        CatStatus activeStatus = catStatusRepo.findByStatus(ACTIVE);
        if (activeStatus == null) {
            throw new NotFoundException("Active status not found");
        }
        Cat cat = catRepo.findByIdAndCatStatus(id,activeStatus);
        if (cat != null) {
            CatResponse catResponse = CatResponse.builder()
                    .type(cat.getType())
                    .description(cat.getDescription())
                    .imgLink(cat.getImgLink())
                    .build();
            return catResponse;
        } else {
            // Handle the case where no shop with the given id is found
            return null;
        }
    }
    }
