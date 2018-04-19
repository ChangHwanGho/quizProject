package com.ibm.quiz.service.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.swing.plaf.synth.SynthSeparatorUI;

import org.springframework.stereotype.Service;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;
import com.amazonaws.services.dynamodbv2.model.ScanRequest;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
import com.ibm.quiz.service.QuizService;

@Service
public class QuizServiceImpl implements QuizService{
   
   static BasicAWSCredentials awsCreds = new BasicAWSCredentials("AKIAI2GR6IU4CBWP7Z7Q", "fYdcSCBbLeIEUYvUHxv5qeVlgWLcFE7wbQCPc5gG");
   
   static AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard()
         .withRegion("ap-northeast-2")
         .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
         .build();
   
   static DynamoDB dynamoDB = new DynamoDB(client);
   
   String table_name = "aws_quiz_show";
   Table workTable = dynamoDB.getTable(table_name);
   
   

   
   public String upDynamo(HttpServletRequest request) {
      ScanRequest scanRequest= new ScanRequest().withTableName(table_name);
      
      ScanResult result = client.scan(scanRequest);
      
      long forKstTime=1000*60*60*9;
      
      Calendar cal = Calendar.getInstance();
      SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss:SSS");
      cal.add(Calendar.HOUR, 9);
      String transactionTime = sdf1.format(cal.getTime());
      
      String serialNo = request.getParameter("serialNo");
      String quizCode = request.getParameter("quizCode");
      String answer = request.getParameter("answer");
      
      Map<String, AttributeValue> data = new HashMap<String, AttributeValue>();
      
      if(serialNo != null && (!serialNo.equals(""))) {
         data.put("serialNo", new AttributeValue().withS(serialNo));
      }
      
      if(transactionTime != null && (!transactionTime.equals(""))) {
         data.put("transactionTime", new AttributeValue().withS(transactionTime));
      }

      if(quizCode != null && (!quizCode.equals(""))) {
         data.put("quizCode", new AttributeValue().withS(quizCode));
      }
      
      if(answer != null && (!answer.equals(""))) {
         data.put("answer", new AttributeValue().withS(answer));
      }
      for(Map<String, AttributeValue> item : result.getItems())
      {

         if(item.get("quizCode").getS().equals(quizCode)&&item.get("answer").getS().equals(answer))
         {

            PutItemRequest itemRequest = new PutItemRequest().withTableName(table_name).withItem(data);
            client.putItem(itemRequest);

            return "notFirst";
         }

      }

      
      try {
         PutItemRequest itemRequest = new PutItemRequest().withTableName(table_name).withItem(data);
         client.putItem(itemRequest);
      } catch (Exception e) {
         // TODO: handle exception
      }

      if(quizCode.equals("IBM")&&!answer.equals("장화진")||quizCode.equals("클라우드")&&!answer.equals("paas")||quizCode.equals("솔루션")&&!answer.equals("garage")||quizCode.equals("컴퓨팅")&&!answer.equals("ec2")||quizCode.equals("인터페이스")&&!answer.equals("api"))
      {
         return "wrong";
      }
      
      return "first";
   }
   
   
   
   
   
}