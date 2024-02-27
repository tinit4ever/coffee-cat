package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.entity_models.Cat;
import com.swd.ccp.models.entity_models.CatStatus;
import com.swd.ccp.models.entity_models.MenuItem;
import com.swd.ccp.models.request_models.ListRequest;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.CatResponse;
import com.swd.ccp.models.response_models.CatListResponse;
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
//    private static final String ACTIVE = "active";
//        @Override
//
//        public CatListResponse getActiveCats(Integer shopId, SortRequest sortRequest) {
//            List<CatStatus> activeStatusList = catStatusRepo.findAllByStatus(ACTIVE);
//            if (activeStatusList.isEmpty()) {
//                return new CatListResponse(Collections.emptyList(), false,null, "No active cats found");
//            }
//            Sort.Direction sortDirection = sortRequest.isAsc() ? Sort.Direction.ASC : Sort.Direction.DESC;
//            Sort sort = Sort.by(sortDirection, sortRequest.getSortByColumn());
//
//            List<Cat> catList = catRepo.findAllByCatStatusIn(activeStatusList, sort);
//
//            List<CatResponse> mappedCatList = mapToCatDtoList(catList, shopId);
//
//            boolean status = true;
//            String message = "Successfully retrieved cat list";
//            String token = accountService.getAccessToken(accountService.getCurrentLoggedUser().getId());
//
//            return new CatListResponse(mappedCatList, status, message, token);
//        }
//
//    private List<CatResponse> mapToCatDtoList(List<Cat> cats, Integer shopId) {
//        if (cats == null) {
//            throw new IllegalArgumentException("Argument cannot be null");
//        }
//
//        if (cats.isEmpty()) {
//            return Collections.emptyList();
//        }
//
//
//        return cats.stream()
//                .filter(cat -> cat.getShop().getId().equals(shopId))
//                .map(cat -> {
//                    CatResponse catResponse = new CatResponse();
//                    catResponse.setDescription(cat.getDescription());
//                    catResponse.setImgLink(cat.getDescription());
//                    catResponse.setType(cat.getType());
//
//                    if (cat.getDescription() == null) {
//                        catResponse.setDescription("N/A");
//                    }
//                    if (cat.getImgLink() == null) {
//                        catResponse.setImgLink("N/A");
//                    }
//                    if (cat.getType() == null) {
//                        catResponse.setType("N/A");
//                    }
//                    return catResponse;
//                }).collect(Collectors.toList());
//    }

    }
