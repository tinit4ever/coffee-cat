package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Booking;
import com.swd.ccp.models.entity_models.BookingDetail;
import com.swd.ccp.models.entity_models.Customer;
import com.swd.ccp.models.request_models.UpdateProfileRequest;
import com.swd.ccp.models.response_models.BookingHistoryResponse;
import com.swd.ccp.models.response_models.CustomerProfile;
import com.swd.ccp.models.response_models.UpdateProfileResponse;
import com.swd.ccp.repositories.BookingDetailRepo;
import com.swd.ccp.repositories.BookingRepo;
import com.swd.ccp.repositories.CustomerRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.CustomerService;
import com.swd.ccp.services.JWTService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomerServiceIml implements CustomerService {
    private final CustomerRepo customerRepo;
    private final JWTService jwtService;
    private final BookingRepo bookingRepo;
    private final BookingDetailRepo bookingDetailRepo;
    private final AccountService accountService;


    @Override
    public CustomerProfile getCustomerProfile(String token) {
        String email = jwtService.extractEmail(token.substring(7));

        if (email != null) {
            Optional<Customer> optionalCustomer = customerRepo.findByAccount_Email(email);
            if (optionalCustomer.isPresent()) {
                Customer customer = optionalCustomer.get();
                CustomerProfile profile = new CustomerProfile();
                profile.setUsername(customer.getAccount().getUsername());
                profile.setEmail(customer.getAccount().getEmail());
                profile.setPhone(customer.getAccount().getPhone());
                profile.setGender(customer.getGender());
                profile.setDob(customer.getDob());
                profile.setStatus(true);
                return profile;
            } else {
                throw new NotFoundException("Customer profile not found.");
            }
        } else {
            throw new IllegalArgumentException("Invalid token");
        }
    }


    @Override
    public UpdateProfileResponse updateProfile(String token, UpdateProfileRequest updateRequest) {
        String email = jwtService.extractEmail(token.substring(7));
        Optional<Customer> optionalProfile = customerRepo.findByAccount_Email(email);
        if (optionalProfile.isPresent()) {
            Customer profile = optionalProfile.get();
            if (updateRequest.getUsername() != null) {
                profile.getAccount().setName(updateRequest.getUsername());
            }
            if (updateRequest.getDob() != null) {
                profile.setDob(updateRequest.getDob());
            }
            if (updateRequest.getGender() != null) {
                profile.setGender(updateRequest.getGender());
            }
            customerRepo.save(profile);

            UpdateProfileResponse response = new UpdateProfileResponse();
            response.setMessage("Profile information updated successfully.");
            response.setStatus(true);

            return response;
        } else {
            throw new NotFoundException("Customer is not found.");
        }
    }

    @Override
    public BookingHistoryResponse getBookingHistory() {
        Customer customer = takeCustomerFromAccount(accountService.getCurrentLoggedUser());
        assert customer != null;
        List<Booking> bookingList = bookingRepo.findAllByCustomer(customer);
        List<BookingHistoryResponse.BookingResponse> bookingResponseList = new ArrayList<>();
        if(bookingList != null && !bookingList.isEmpty()){
            for(Booking booking: bookingList){
                bookingResponseList.add(
                        BookingHistoryResponse.BookingResponse.builder()
                                .bookingID(booking.getId())
                                .shopName(booking.getShopName())
                                .seatName(booking.getSeatName())
                                .areaName(booking.getSeat().getArea().getName())
                                .totalPrice(calculateTotalPrice(booking))
                                .bookingDate(booking.getBookingDate())
                                .status(booking.getBookingStatus().getStatus())
                                .build()
                );
            }

            return BookingHistoryResponse.builder()
                    .status(true)
                    .message("Get list successfully")
                    .bookingList(bookingResponseList)
                    .build();
        }
        return BookingHistoryResponse.builder()
                .status(false)
                .message("Fail to get list")
                .bookingList(null)
                .build();
    }

    private Customer takeCustomerFromAccount(Account account){
        Customer customer = customerRepo.findByAccount_Email(account.getEmail()).orElse(null);
        assert customer != null;
        return customer;
    }

    private float calculateTotalPrice(Booking booking){
        float result = 0;
        List<BookingDetail> bookingDetailList = bookingDetailRepo.findAllByBooking(booking);
        if(bookingDetailList != null && !bookingDetailList.isEmpty()){
            for(BookingDetail item: bookingDetailList){
                result += item.getPrice();
            }
        }
        return result;
    }
}
