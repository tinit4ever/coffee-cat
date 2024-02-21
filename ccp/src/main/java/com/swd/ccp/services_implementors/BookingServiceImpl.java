package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.MenuItem;
import com.swd.ccp.models.entity_models.Seat;
import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.request_models.UpdateBookingCartRequest;
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
        BookingCartResponse bookingCartResponse = new BookingCartResponse();

        //Check if new seat is existed
        Seat newSeat = seatRepo.findById(request.getNewCart().getSeatID()).orElse(null);

        if(newSeat != null && !newSeat.getId().equals(request.getOldCart().getSeatID())){

        }
        return null;
    }
}

