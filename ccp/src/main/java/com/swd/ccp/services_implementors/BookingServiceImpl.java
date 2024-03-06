package com.swd.ccp.services_implementors;

import com.swd.ccp.enums.Constant;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.CancelBookingRequest;
import com.swd.ccp.models.request_models.CreateBookingCartRequest;
import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.request_models.UpdateBookingCartRequest;
import com.swd.ccp.models.response_models.BookingCartResponse;
import com.swd.ccp.models.response_models.CancelBookingResponse;
import com.swd.ccp.models.response_models.CreateBookingResponse;
import com.swd.ccp.repositories.*;
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

    private final CustomerRepo customerRepo;

    private final BookingStatusRepo bookingStatusRepo;

    private final BookingDetailRepo bookingDetailRepo;

    private final BookingRepo bookingRepo;


    @Override
    public BookingCartResponse createBookingCart(CreateBookingCartRequest request) {
        BookingCartResponse.BookingCartShopResponse bookingCartShopResponse = new BookingCartResponse.BookingCartShopResponse();
        List<BookingCartResponse.BookingCartShopMenuResponse> bookingCartShopMenuResponseList = new ArrayList<>();

        Seat seat = seatRepo.findById(request.getSeatId()).orElse(null);
        if(seat != null && seat.getSeatStatus().getStatus().equals("available")){
            if(request.getMenuItemList() != null && !request.getMenuItemList().isEmpty()){

                request.getMenuItemList().forEach(
                        item -> {
                            MenuItem menuItem = menuItemRepo.findById(item.getItemId()).orElse(null);
                            if(menuItem != null && Constant.MAX_BOOKING_MENU_ITEM_QUANTITY >= item.getQuantity()){
                                bookingCartShopMenuResponseList.add(
                                        BookingCartResponse.BookingCartShopMenuResponse.builder()
                                                .itemId(menuItem.getId())
                                                .itemName(menuItem.getName())
                                                .itemPrice(menuItem.getPrice() * item.getQuantity())
                                                .quantity(item.getQuantity())
                                                .build()
                                );
                            }
                        }
                );

                shopRepo.findById(seat.getArea().getShop().getId()).ifPresent(shop -> {
                    bookingCartShopResponse.setShopId(shop.getId());
                    bookingCartShopResponse.setShopName(shop.getName());
                    bookingCartShopResponse.setSeatId(seat.getId());
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
                    .bookingCartShopResponse(bookingCartShopResponse)
                    .build();
        }

        return BookingCartResponse.builder()
                .status(false)
                .message("Seat is busy")
                .bookingCartShopResponse(null)
                .build();
    }

    @Override
    public BookingCartResponse updateBookingCart(UpdateBookingCartRequest request) {
        List<BookingCartResponse.BookingCartShopMenuResponse> shopMenuResponseList = new ArrayList<>();

        Seat newSeat = seatRepo.findById(request.getNewCart().getSeatId()).orElse(null);

        //Check if new seat is existed, then access menu item
        if(newSeat != null && !newSeat.getSeatStatus().getStatus().equals("busy")){
            request.getNewCart().getList().forEach(
                    item -> {
                        MenuItem menuItem = menuItemRepo.findById(item.getItemId()).orElse(null);
                        if(menuItem != null){
                            if(Constant.MAX_BOOKING_MENU_ITEM_QUANTITY >= item.getQuantity()){
                                shopMenuResponseList.add(BookingCartResponse.BookingCartShopMenuResponse.builder()
                                                .itemId(menuItem.getId())
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
                    .bookingCartShopResponse(
                            BookingCartResponse.BookingCartShopResponse.builder()
                                    .shopId(newSeat.getArea().getShop().getId())
                                    .shopName(newSeat.getArea().getShop().getName())
                                    .seatId(newSeat.getId())
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
                .bookingCartShopResponse(null)
                .build();
    }

    @Override
    public CreateBookingResponse createBooking(CreateBookingRequest request) {
        String errorMsg = createBookingDetail(request);
        if(errorMsg.isEmpty()){
            return CreateBookingResponse.builder()
                    .status(true)
                    .message("Booking successfully")
                    .bookingDate(request.getBookingDate())
                    .build();
        }
        return CreateBookingResponse.builder()
                .status(false)
                .message(errorMsg)
                .bookingDate(null)
                .build();
    }

    @Override
    public CancelBookingResponse cancelBooking(CancelBookingRequest request) {

        Booking booking = bookingRepo.findById(request.getBookingId()).orElse(null);
        if(booking != null && booking.getBookingStatus().getStatus().equals("pending")){
            booking.setBookingStatus(bookingStatusRepo.findByStatus("cancelled"));
            for(BookingDetail detail: booking.getBookingDetailList()){
                MenuItem item = menuItemRepo.findById(detail.getMenuItem().getId()).orElse(null);
                assert item != null;
                item.setSoldQuantity(item.getSoldQuantity() - detail.getQuantity());
                menuItemRepo.save(item);
            }
            bookingRepo.save(booking);
            return CancelBookingResponse.builder()
                    .status(true)
                    .message("Cancel booking successfully")
                    .build();
        }
        return CancelBookingResponse.builder()
                .status(false)
                .message("This booking is not existed or something happened")
                .build();
    }

    private String createBookingDetail(CreateBookingRequest request){
        Seat seat = seatRepo.findById(request.getSeatId()).orElse(null);

        if(seat != null){
            Customer customer = customerRepo.findByAccount_Email(accountService.getCurrentLoggedUser().getEmail()).orElse(null);
            if(customer != null){
                Booking booking = Booking.builder()
                        .seat(seat)
                        .customer(customer)
                        .bookingStatus(bookingStatusRepo.findByStatus("pending"))
                        .shopName(seat.getArea().getShop().getName())
                        .seatName(seat.getName())
                        .extraContent(request.getExtraContent())
                        .createDate(new Date(System.currentTimeMillis()))
                        .bookingDate(request.getBookingDate())
                        .build();
                bookingRepo.save(booking);

                for(CreateBookingRequest.BookingShopMenuRequest item: request.getBookingShopMenuRequestList()){
                    MenuItem i = menuItemRepo.findById(item.getItemId()).orElse(null);
                    if(i != null && item.getQuantity() <= Constant.MAX_BOOKING_MENU_ITEM_QUANTITY){
                        bookingDetailRepo.save(
                                BookingDetail.builder()
                                        .booking(booking)
                                        .menuItem(i)
                                        .price(i.getPrice())
                                        .quantity(item.getQuantity())
                                        .build()
                        );

                        i.setSoldQuantity(i.getSoldQuantity() + item.getQuantity());
                        menuItemRepo.save(i);
                    }
                    return "The quantity booked must be " + Constant.MAX_BOOKING_MENU_ITEM_QUANTITY + " as maximum";
                }
                return "";
            }
            return "This account is not a customer";
        }
        return "Seat is not existed";
    }

}

