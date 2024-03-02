package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.GetAreaListRequest;
import com.swd.ccp.models.response_models.AreaListResponse;
import com.swd.ccp.models.response_models.AreaResponse;
import com.swd.ccp.models.response_models.CatResponse;
import com.swd.ccp.models.response_models.SeatResponse;
import com.swd.ccp.repositories.AreaRepo;
import com.swd.ccp.repositories.AreaStatusRepo;
import com.swd.ccp.repositories.BookingRepo;
import com.swd.ccp.services.AreaService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class AreaServiceImpl implements AreaService {
    private final AreaRepo areaRepo;
    private final BookingRepo bookingRepo;
    private final AreaStatusRepo areaStatusRepo;

    public AreaListResponse getAreasWithSeatsAndActiveCats(GetAreaListRequest request) {
        List<AreaStatus> activeAreaStatusList = areaStatusRepo.findAllByStatus("active");
        if (activeAreaStatusList.isEmpty()) {
            return new AreaListResponse(Collections.emptyList(), false, "No active areas found");
        }

        List<Area> areaList = areaRepo.findByShopId(request.getShopId());
        List<AreaResponse> areaResponseList = new ArrayList<>();

        for (Area area : areaList) {
            List<Seat> seatList = area.getSeatList();

            seatList.sort(Comparator.comparing(Seat::getId));

            List<SeatResponse> seatResponseList = new ArrayList<>();

            for (Seat seat : seatList) {
                Booking booking = bookingRepo.findBySeatAndBookingDate(seat, request.getDate()).orElse(null);

                boolean isBooked = booking != null && !booking.getBookingStatus().getStatus().equals("Cancelled");
                SeatResponse seatResponseDTO = SeatResponse.builder()
                        .id(seat.getId())
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
