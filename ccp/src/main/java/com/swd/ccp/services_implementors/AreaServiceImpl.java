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
        AreaStatus areaStatus = areaStatusRepo.findByStatus("active").orElse(null);
        assert areaStatus != null;
        List<Area> areaList = areaRepo.findAllByShopIdAndAndAreaStatus(request.getShopId(), areaStatus);
        List<AreaResponse> areaResponseList = new ArrayList<>();

        if(areaList.isEmpty()){
            return AreaListResponse.builder()
                    .status(false)
                    .message("No area available")
                    .areaResponseList(Collections.emptyList())
                    .build();
        }

        for (Area area : areaList) {
            List<Seat> seatList = area.getSeatList();

            seatList.sort(Comparator.comparing(Seat::getId));

            List<SeatResponse> seatResponseList = new ArrayList<>();

            for (Seat seat : seatList) {
                Booking booking = bookingRepo.findBySeatAndBookingDate(seat, request.getDate()).orElse(null);

                boolean notAvailable = (booking != null
                        && !booking.getBookingStatus().getStatus().equals("Cancelled"))
                        || seat.getSeatStatus().getStatus().equals("unavailable");
                SeatResponse seatResponseDTO = SeatResponse.builder()
                        .id(seat.getId())
                        .name(seat.getName())
                        .status(!notAvailable)
                        .build();
                seatResponseList.add(seatResponseDTO);
            }

            List<CatResponse> activeCatList = new ArrayList<>();


            AreaResponse areaResponseDTO = AreaResponse.builder()
                    .id(area.getId())
                    .name(area.getName())
                    .seatList(seatResponseList)
                    .catList(activeCatList)
                    .build();

            areaResponseList.add(areaResponseDTO);
        }
        return AreaListResponse.builder()
                .status(true)
                .message("Successfully retrieved area list")
                .areaResponseList(areaResponseList)
                .build();
    }

}
