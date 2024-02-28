package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.AreaListResponse;
import com.swd.ccp.models.response_models.AreaResponse;
import com.swd.ccp.models.response_models.CatResponse;
import com.swd.ccp.models.response_models.SeatResponse;
import com.swd.ccp.repositories.AreaRepo;
import com.swd.ccp.repositories.AreaStatusRepo;
import com.swd.ccp.repositories.BookingRepo;
import com.swd.ccp.services.AreaService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class AreaServiceIpml implements AreaService {
    private final AreaRepo areaRepo;
    private final BookingRepo bookingRepo;
    private final AreaStatusRepo areaStatusRepo;
    public AreaListResponse getAreasWithSeatsAndActiveCats(Integer shopId, Date date) {
        List<AreaStatus> activeAreaStatusList = areaStatusRepo.findAllByStatus("active");
        if (activeAreaStatusList.isEmpty()) {
            return new AreaListResponse(Collections.emptyList(), false, "No active areas found");
        }

        List<Area> areaList = areaRepo.findByShopId(shopId);
        List<AreaResponse> areaResponseList = new ArrayList<>();

        for (Area area : areaList) {
            List<Seat> seatList = area.getSeatList();

            seatList.sort(Comparator.comparing(Seat::getName).reversed());

            List<SeatResponse> seatResponseList = new ArrayList<>();

            for (Seat seat : seatList) {

                boolean isBooked = bookingRepo.existsBySeatIdAndBookingDate(seat.getId(), date);
                SeatResponse seatResponseDTO = SeatResponse.builder()
                        .name(seat.getName())
                        .status(!isBooked)
                        .build();
                seatResponseList.add(seatResponseDTO);
            }

            List<CatResponse> activeCatList = new ArrayList<>();


            AreaResponse areaResponseDTO = AreaResponse.builder()
                    .name(area.getName())
                    .seatList(seatResponseList)
                    .catList(activeCatList)
                    .build();

            areaResponseList.add(areaResponseDTO);
        }

        return new AreaListResponse(areaResponseList, true, "Successfully retrieved area list");
    }

}
