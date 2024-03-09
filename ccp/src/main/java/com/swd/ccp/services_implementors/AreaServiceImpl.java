package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.GetAreaListRequest;
import com.swd.ccp.models.response_models.AreaListResponse;
import com.swd.ccp.models.response_models.AreaResponse;
import com.swd.ccp.models.response_models.CatResponse;
import com.swd.ccp.models.response_models.SeatResponse;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.AreaService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class AreaServiceImpl implements AreaService {
    private final AreaRepo areaRepo;
    private final SeatRepo seatRepo;
    private final BookingRepo bookingRepo;
    private final AreaStatusRepo areaStatusRepo;
    private final SeatStatusRepo seatStatusRepo;

    public AreaListResponse getAreasWithSeatsAndActiveCats(GetAreaListRequest request) {
        AreaStatus areaStatus = areaStatusRepo.findByStatus("active");
        SeatStatus seatStatus = seatStatusRepo.findByStatus("available");
        assert seatStatus != null;
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
            List<Seat> seatList = seatRepo.findAllByAreaAndSeatStatus(area, seatStatus);

            seatList.sort(Comparator.comparing(Seat::getId));

            List<SeatResponse> seatResponseList = new ArrayList<>();

            for (Seat seat : seatList) {
                Booking booking = bookingRepo.findBySeatAndBookingDate(seat, request.getDate()).orElse(null);

                boolean notAvailable = (booking != null
                        && !booking.getBookingStatus().getStatus().equals("cancelled"))
                        || seat.getSeatStatus().getStatus().equals("unavailable");
                SeatResponse seatResponseDTO = SeatResponse.builder()
                        .id(seat.getId())
                        .name(seat.getName())
                        .capacity(seat.getCapacity())
                        .status(!notAvailable)
                        .build();
                seatResponseList.add(seatResponseDTO);
            }

            List<CatResponse> activeCatList = area.getCatList().stream()
                    .map(cat -> new CatResponse(cat.getId(), cat.getName(), cat.getType(), cat.getDescription(), cat.getImgLink()))
                    .toList();

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
