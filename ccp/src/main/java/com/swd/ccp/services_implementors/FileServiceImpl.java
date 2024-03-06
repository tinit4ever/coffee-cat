package com.swd.ccp.services_implementors;

import com.swd.ccp.services.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FileServiceImpl implements FileService {
    @Override
    public String readEmailTemplate(String email, String password) throws Exception{
        List<String> fileData = getFileData();
        StringBuilder result = new StringBuilder();
        for(String line: fileData){
            result.append(line);
        }
        String[] cutResult = result.toString().split("@@@###");
        result = new StringBuilder();
        result.append(cutResult[0])
                .append(email)
                .append(cutResult[1])
                .append(password)
                .append(cutResult[2]);

        return result.toString();
    }

    private List<String> getFileData() throws Exception{
        BufferedReader br = new BufferedReader(new FileReader("src/main/java/com/swd/ccp/files/EmailTemplate.txt"));
        List<String> result = new ArrayList<>();
        String line;
        while ((line = br.readLine()) != null){
            result.add(line);
        }
        br.close();
        return result;
    }

//    public static void main(String[] args) throws Exception{
//        FileServiceImpl fileService = new FileServiceImpl();
//        System.out.println(fileService.readEmailTemplate("haha", "lmao"));
//    }
}
