<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>AWS Session April, 2018</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
<style>
table { 
  width: 100%; 
  border-collapse: collapse; 
}
/* Zebra striping */
tr:nth-of-type(odd) { 
  background: #eee; 
}
th { 
  background: #333; 
  color: white; 
  font-weight: bold; 
}
td, th { 
  padding: 6px; 
  border: 1px solid #ccc; 
  text-align: left; 
}

</style>
<body>
	<table>
		<thead>
			<tr>
				<th>사번</th>
				<th>퀴즈코드</th>
				<th>제출시각</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${quizList}" var="quizList">
				<tr>
					<td style="text-align: center;">${quizList.serialNo}</td>
					<td style="text-align: center;">${quizList.quizCode}</td>
					<td style="text-align: center;">${quizList.transactionTime}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>




</body>



</html>
