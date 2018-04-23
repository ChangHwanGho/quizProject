package com.ibm.quiz.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ibm.quiz.service.QuizService;

@Controller
public class QuizController {
	
	@Autowired
	QuizService quizService;
	
	@GetMapping(value="/main")
	public ModelAndView showChoosePage() {
		ModelAndView mav = new ModelAndView("main");
		return mav;
	}
	
	@PostMapping(value="/first")
	public ModelAndView showResultPage() {
		ModelAndView mav = new ModelAndView("first");
		return mav;
	}
	
	@PostMapping(value="/notFirst")
	public ModelAndView showResultPage1() {
		ModelAndView mav = new ModelAndView("notFirst");
		return mav;
	}
	
	@GetMapping(value="/congratulation")
	public ModelAndView showCongratulationPage() {
		ModelAndView mav = new ModelAndView("congratulation");	
		List<Map<String, String>> list = quizService.getDynamo();
		String winner = list.get(randomRange(0, list.size())).get("serialNo");
		
		mav.addObject("winner", winner);
		return mav;
	}
	
  public int randomRange(int n1, int n2) {
    return (int) (Math.random() * (n2 - n1 + 1)) + n1;
  }

	@GetMapping(value="/dynamo")
	public ModelAndView showDynamoPage() {
		ModelAndView mav = new ModelAndView("dynamo");

		mav.addObject("quizList", quizService.getDynamo());
		
		return mav;
	}

	@GetMapping(value="/result")
	@ResponseBody
	public String showQuestionPage(HttpServletResponse response, HttpServletRequest request) {
		
		String result="";
		
		String serialNo = request.getParameter("serialNo");
		if(serialNo!=null&&!serialNo.equals("")) {
			result=quizService.upDynamo(request);
		}
		return result;
	}
	

	
}
