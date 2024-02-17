package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.MenuItem;
import com.swd.ccp.models.entity_models.Seat;
import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.response_models.BookingCartResponse;
import com.swd.ccp.models.response_models.BookingCartShopMenuResponse;
import com.swd.ccp.models.response_models.BookingCartShopResponse;
import com.swd.ccp.repositories.MenuItemRepo;
import com.swd.ccp.repositories.SeatRepo;
import com.swd.ccp.repositories.SeatStatusRepo;
import com.swd.ccp.repositories.ShopRepo;
import com.swd.ccp.services.BookingCartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingCartServiceImpl implements BookingCartService {

    private final SeatRepo seatRepo;

    private final SeatStatusRepo seatStatusRepo;

    private final MenuItemRepo menuItemRepo;

    private final ShopRepo shopRepo;



    @Override
    public BookingCartResponse createBookingCart(CreateBookingRequest request) {
        List<BookingCartShopResponse> bookingCartShopResponseList = new ArrayList<>();
        List<BookingCartShopMenuResponse> bookingCartShopMenuResponseList = new ArrayList<>();

        Seat seat = seatRepo.findById(request.getSeatID()).orElse(null);
        if(seat != null && seat.getSeatStatus().getStatus().equals("available")){
            if(request.getMenuItemList() != null && !request.getMenuItemList().isEmpty()){
                request.getMenuItemList().keySet().forEach(itemID -> {
                    MenuItem menuItem = menuItemRepo.findById(Integer.parseInt(itemID)).orElse(null);
                    if(menuItem != null && menuItem.getQuantity() - request.getMenuItemList().get(itemID) >= 0){
                        bookingCartShopMenuResponseList.add(
                                BookingCartShopMenuResponse.builder()
                                        .itemName(menuItem.getName())
                                        .itemPrice(menuItem.getPrice())
                                        .quantity(request.getMenuItemList().get(itemID))
                                        .build()
                        );
                    }
                });

                Shop shop = shopRepo.findById(seat.getId()).orElse(null);
                if(shop != null){
                    bookingCartShopResponseList.add(
                            BookingCartShopResponse.builder()
                                    .shopName(shop.getName())
                                    .seatName(seat.getName())
                                    .createDate(new Date(System.currentTimeMillis()))
                                    .bookingDate(request.getBookingDate())
                                    .status(seat.getSeatStatus().getStatus())
                                    .extraContent(request.getExtraContent())
                                    .bookingCartShopMenuResponseList(bookingCartShopMenuResponseList)
                                    .build()
                    );
                }
            }

            return BookingCartResponse.builder()
                    .message("")
                    .bookingCartShopResponseList(bookingCartShopResponseList)
                    .build();
        }

        return BookingCartResponse.builder()
                .message("Seat is busy")
                .bookingCartShopResponseList(null)
                .build();
    }
}

