package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.MenuItem;
import com.swd.ccp.models.entity_models.Seat;
import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.response_models.BookingCartResponse;
import com.swd.ccp.repositories.MenuItemRepo;
import com.swd.ccp.repositories.SeatRepo;
import com.swd.ccp.repositories.SeatStatusRepo;
import com.swd.ccp.repositories.ShopRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.BookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {

    private final SeatRepo seatRepo;

    private final SeatStatusRepo seatStatusRepo;

    private final MenuItemRepo menuItemRepo;

    private final ShopRepo shopRepo;

    private final AccountService accountService;



    @Override
    public BookingCartResponse createBookingCart(CreateBookingRequest request) {
        List<BookingCartResponse.BookingCartShopResponse> bookingCartShopResponseList = new ArrayList<>();
        List<BookingCartResponse.BookingCartShopMenuResponse> bookingCartShopMenuResponseList = new ArrayList<>();

        Seat seat = seatRepo.findById(request.getSeatID()).orElse(null);
        if(seat != null && seat.getSeatStatus().getStatus().equals("available")){
            if(request.getMenuItemList() != null && !request.getMenuItemList().isEmpty()){

                request.getMenuItemList().forEach(
                        item -> {
                            MenuItem menuItem = menuItemRepo.findById(item.getItemID()).orElse(null);
                            if(menuItem != null && menuItem.getQuantity() - item.getQuantity() >= 0){
                                bookingCartShopMenuResponseList.add(
                                        BookingCartResponse.BookingCartShopMenuResponse.builder()
                                                .itemID(menuItem.getId())
                                                .itemName(menuItem.getName())
                                                .itemPrice(menuItem.getPrice() * item.getQuantity())
                                                .quantity(item.getQuantity())
                                                .build()
                                );
                            }
                        }
                );

                shopRepo.findById(seat.getId()).ifPresent(shop -> bookingCartShopResponseList.add(
                        BookingCartResponse.BookingCartShopResponse.builder()
                                .shopName(shop.getName())
                                .seatName(seat.getName())
                                .createDate(new Date(System.currentTimeMillis()))
                                .bookingDate(request.getBookingDate())
                                .status(seat.getSeatStatus().getStatus())
                                .extraContent(request.getExtraContent())
                                .bookingCartShopMenuResponseList(bookingCartShopMenuResponseList)
                                .build()
                ));
            }


            return BookingCartResponse.builder()
                    .status(true)
                    .message("")
                    .token(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()))
                    .bookingCartShopResponseList(bookingCartShopResponseList)
                    .build();
        }

        return BookingCartResponse.builder()
                .status(false)
                .message("Seat is busy")
                .token(null)
                .bookingCartShopResponseList(null)
                .build();
    }
}

