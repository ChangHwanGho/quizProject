package com.ibm.quiz.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


public interface QuizService {
	public String upDynamo(HttpServletRequest request);
	public List<Map<String, String>> getDynamo();
	public String congratulation();
}
