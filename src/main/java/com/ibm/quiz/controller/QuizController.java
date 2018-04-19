package com.ibm.quiz.controller;

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
