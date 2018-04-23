package com.ibm.quiz.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
   
	//dynamoDB access Key.
   static BasicAWSCredentials awsCreds = new BasicAWSCredentials("AKIAI2GR6IU4CBWP7Z7Q", "fYdcSCBbLeIEUYvUHxv5qeVlgWLcFE7wbQCPc5gG");
   
   //set client.
   static AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard()
         .withRegion("ap-northeast-2")
         .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
         .build();
   
   //DB connection.
   static DynamoDB dynamoDB = new DynamoDB(client);
   
   //set table name.
   String table_name = "aws_quiz_show";
   Table workTable = dynamoDB.getTable(table_name);
   
   //get data by scan.
   public List<Map<String, String>> getDynamo() {
	   
	   List<Map<String, String>> dynamoResult = new ArrayList<Map<String, String>>();
		
	   ScanRequest scanRequest= new ScanRequest().withTableName(table_name);
	   
	   ScanResult result = client.scan(scanRequest);
	   

	   
	for (Map<String, AttributeValue> item : result.getItems()) {
		
		Map<String, String> map = new HashMap<>();
		map.put("serialNo", item.get("serialNo").getS());
		map.put("quizCode", item.get("quizCode").getS());
		map.put("transactionTime",item.get("transactionTime").getS());
		dynamoResult.add(map);
	}
 
	   return dynamoResult;

   }
   
   

   //update date.
   public String upDynamo(HttpServletRequest request) {
      ScanRequest scanRequest= new ScanRequest().withTableName(table_name);
      
      ScanResult result = client.scan(scanRequest);
      
      //set KTC
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

      if(quizCode.equals("IBM")&&!answer.equals("장화진")
    		  ||quizCode.equals("서버리스")&&!answer.equals("false")
    		  ||quizCode.equals("서비스")&&!answer.equals("function")
    		  ||quizCode.equals("툴체인")&&!answer.equals("process")
    		  ||quizCode.equals("SQS")&&!answer.equals("queue")
    		  ||quizCode.equals("코드디플로이")&&!answer.equals("false")
    		  ||quizCode.equals("파이프")&&!answer.equals("codepipeline")
    		  ||quizCode.equals("시계")&&!answer.equals("cloudwatch")
    		  ||quizCode.equals("디비")&&!answer.equals("dynamodb")
    		  ||quizCode.equals("컴퓨팅")&&!answer.equals("lambda")
    	)
      {
         return "wrong";
      }
      
      return "first";
   }
   
   
   
   
   public String congratulation()
   {
	   
	   return null;
   }
   
}