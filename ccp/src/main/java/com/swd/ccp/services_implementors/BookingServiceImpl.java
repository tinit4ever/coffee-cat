package com.swd.ccp.services_implementors;

import com.swd.ccp.enums.Constant;
import com.swd.ccp.models.entity_models.MenuItem;
import com.swd.ccp.models.entity_models.Seat;
import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.request_models.UpdateBookingCartRequest;
import com.swd.ccp.models.response_models.BookingCartResponse;
import com.swd.ccp.repositories.MenuItemRepo;
import com.swd.ccp.repositories.SeatRepo;
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

    private final MenuItemRepo menuItemRepo;

    private final ShopRepo shopRepo;

    private final AccountService accountService;




    @Override
    public BookingCartResponse createBookingCart(CreateBookingRequest request) {
        BookingCartResponse.BookingCartShopResponse bookingCartShopResponse = new BookingCartResponse.BookingCartShopResponse();
        List<BookingCartResponse.BookingCartShopMenuResponse> bookingCartShopMenuResponseList = new ArrayList<>();

        Seat seat = seatRepo.findById(request.getSeatID()).orElse(null);
        if(seat != null && seat.getSeatStatus().getStatus().equals("available")){
            if(request.getMenuItemList() != null && !request.getMenuItemList().isEmpty()){

                request.getMenuItemList().forEach(
                        item -> {
                            MenuItem menuItem = menuItemRepo.findById(item.getItemID()).orElse(null);
                            if(menuItem != null && Constant.MAX_BOOKING_MENU_ITEM_QUANTITY - item.getQuantity() >= 0){
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

                shopRepo.findById(seat.getShop().getId()).ifPresent(shop -> {
                    bookingCartShopResponse.setShopID(shop.getId());
                    bookingCartShopResponse.setShopName(shop.getName());
                    bookingCartShopResponse.setSeatID(seat.getId());
                    bookingCartShopResponse.setSeatName(seat.getName());
                    bookingCartShopResponse.setCreateDate(new Date(System.currentTimeMillis()));
                    bookingCartShopResponse.setBookingDate(request.getBookingDate());
                    bookingCartShopResponse.setStatus(seat.getSeatStatus().getStatus());
                    bookingCartShopResponse.setExtraContent(request.getExtraContent());
                    bookingCartShopResponse.setBookingCartShopMenuResponseList(bookingCartShopMenuResponseList);
                });
            }


            return BookingCartResponse.builder()
                    .status(true)
                    .message("")
                    .token(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()))
                    .bookingCartShopResponse(bookingCartShopResponse)
                    .build();
        }

        return BookingCartResponse.builder()
                .status(false)
                .message("Seat is busy")
                .token(null)
                .bookingCartShopResponse(null)
                .build();
    }

    @Override
    public BookingCartResponse updateBookingCart(UpdateBookingCartRequest request) {
        List<BookingCartResponse.BookingCartShopMenuResponse> shopMenuResponseList = new ArrayList<>();

        Seat newSeat = seatRepo.findById(request.getNewCart().getSeatID()).orElse(null);

        //Check if new seat is existed, then access menu item
        if(newSeat != null && !newSeat.getSeatStatus().getStatus().equals("busy")){
            request.getNewCart().getBookingCartShopMenuResponseList().forEach(
                    item -> {
                        MenuItem menuItem = menuItemRepo.findById(item.getItemID()).orElse(null);
                        if(menuItem != null){
                            if(Constant.MAX_BOOKING_MENU_ITEM_QUANTITY - item.getQuantity() >= 0){
                                shopMenuResponseList.add(BookingCartResponse.BookingCartShopMenuResponse.builder()
                                                .itemID(menuItem.getId())
                                                .itemName(menuItem.getName())
                                                .itemPrice(menuItem.getPrice() * item.getQuantity())
                                                .quantity(item.getQuantity())
                                        .build());
                            }
                        }
                    }
            );

            return BookingCartResponse.builder()
                    .status(true)
                    .message("Update booking successfully")
                    .token(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()))
                    .bookingCartShopResponse(
                            BookingCartResponse.BookingCartShopResponse.builder()
                                    .shopID(newSeat.getShop().getId())
                                    .shopName(newSeat.getShop().getName())
                                    .seatID(newSeat.getId())
                                    .seatName(newSeat.getName())
                                    .createDate(new Date(System.currentTimeMillis()))
                                    .bookingDate(request.getNewCart().getBookingDate())
                                    .status(newSeat.getSeatStatus().getStatus())
                                    .extraContent(request.getNewCart().getExtraContent())
                                    .bookingCartShopMenuResponseList(shopMenuResponseList)
                                    .build()
                    )
                    .build();

        }
        return BookingCartResponse.builder()
                .status(false)
                .message("Selected seat is busy")
                .token(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()))
                .bookingCartShopResponse(null)
                .build();
    }
}

