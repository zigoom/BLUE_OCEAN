<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="CP" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.0.js" integrity="sha256-JlqSTELeR4TLqP0OG9dxM7yDPqX1ox/HfgiSLBj8+kM=" crossorigin="anonymous"></script>
<script src="https://unpkg.com/lightweight-charts/dist/lightweight-charts.standalone.production.js"></script>
<script src="https://kit.fontawesome.com/649b25c1cf.js" crossorigin="anonymous"></script>
<link rel="stylesheet" href="${CP}/resources/css/header.css" />
<link rel="stylesheet" href="${CP}/resources/css/footer.css" />
<style>
#chart-container {
	width: 20%;
	height: 100px;
}
</style>
</head>
<body>
	<div class="container">
		<div class="bookmark-container">
			<div class="chart-container">
				<div id="chart-container"></div>
			</div>
			<div class="text-container"></div>
		</div>
	</div>
	<p>하는 주식의 Ticker와 시작/종료 날짜를 입력해 주세요.</p>
	<label> 주식값 : <input type="text" name="Ticker" id="Ticker" value="000020" />
	</label>
	<label> 시작날짜 : <input type="text" name="StartDate" id="StartDate" value="2000-01-01" />
	</label>
	<label> 종료날짜 : <input type="text" name="EndDate" id="EndDate" value="2023-07-27" />
	</label>
	<label> <input type="button" value="데이터 요청" onclick="test()" />
	</label>
</body>
<script src="${CP}/resources/js/header.js"></script>
<script>
	// 20200101 등의 값을 2020-01-01 로 변경해주는 함수
	function formatDate(date) {
		const dateString = date.toString();
		const year = dateString.slice(0, 4);
		const month = dateString.slice(4, 6);
		const day = dateString.slice(6, 8);

		return year + '-' + month + '-' + day;
	}
	// 차트 생성
	const chart = LightweightCharts.createChart(document
			.getElementById('chart-container'), {
		layout : {
			textColor : 'black',
			backgroundColor : 'white',
		},
	});

	// 시리즈 생성
	const lineSeries = chart.addLineSeries();

	// 데이터 설정
	const chartData = [];

	// 시간 척도 설정
	const timeScale = chart.timeScale();

	function test() {
		let ticker_data = $('#Ticker').val(); // 주식종목 코드
		let startDate_data = $('#StartDate').val(); // 시작일
		let endDate_data = $('#EndDate').val(); // 종료일

		let requestData = {
			ticker : ticker_data, // "005930",
			startDate : startDate_data, // "2023-01-02",
			endtDate : endDate_data, // "2023-01-31"
		};
		// ajax를 활용해 http://192.168.0.74:5001/blue-oceans/search-tickers을 호출하여 불러온 데이터를 파싱
		$
				.ajax({
					type : 'POST',
					url : 'http://192.168.0.74:5001/blue-oceans/search-tickers',
					data : JSON.stringify(requestData),
					contentType : 'application/json',
					mode : 'cors',
					success : function(result) {
						$('#stock-name').text(
								result.stock_name + '(' + result.ticker + ')');
						let parsedData = JSON.parse(result.data);
						let lastCloseValue; // 마지막 Close값
						let lastCloseValuePreviousDay; // 마지막 전날 Close값

						parsedData.forEach(function(data, index) {
							console.log(data.Volume);
							chartData.push({
								time : formatDate(data.Date),
								value : data.Close,
							});
							lastCloseValue = data.Close; // 마지막 Close 값 저장

							if (index === parsedData.length - 2) {
								lastCloseValuePreviousDay = data.Close; // 마지막 전날 Close 값 저장
							}
							// 거래량 , 시가 , 고가, 저가를 불러오고 해당 html에 toLocaleString 으로 천의 자릿수마다 콤마를 찍어준뒤 출력
							$('.volume').text(data.Volume.toLocaleString());
							$('.open').text(data.Open.toLocaleString());
							$('.high').text(data.High.toLocaleString());
							$('.low').text(data.Low.toLocaleString());
						});
						// 가져온데이터 차트에 등록
						lineSeries.setData(chartData);

						// lastCloseValue와 lastCloseValuePreviousDay 변수를 이용하여 원하는 작업 수행
						console.log('마지막 Close 값:', lastCloseValue);
						$('.last-close-value').text(
								lastCloseValue.toLocaleString());
						$('.prev-close').text(
								lastCloseValuePreviousDay.toLocaleString());

						if (lastCloseValuePreviousDay) {
							console.log('전날 마지막 Close 값:',
									lastCloseValuePreviousDay);
							if (lastCloseValue - lastCloseValuePreviousDay >= 0) {
								//  마지막날값에서 마지막 전날값을 뺐을때 0보다 크다면
								//  해당 div색을 상승시 빨간색으로 바꾸고 ▲ 모양과 함께 마지막날값에서 마지막 전날값을 뺀 금액과
								//  %로 계산한것을 해당 html에 출력 , 하락시 반대로 적용
								$('.price-changes')
										.text(
												'▲'
														+ (lastCloseValue - lastCloseValuePreviousDay)
																.toLocaleString());
								$('.price-changes-percent')
										.text(
												'▲'
														+ (((lastCloseValue - lastCloseValuePreviousDay) / lastCloseValuePreviousDay) * 100)
																.toFixed(2));
								$('.price-changes').css('color', 'red');
								$('.price-changes-percent').css('color', 'red');
								$('.last-close-value').css('color', 'red');
								$('#price-change-box').css('background-color',
										'#FCEDEB');
							} else {
								$('.price-changes')
										.text(
												'▼'
														+ (lastCloseValue - lastCloseValuePreviousDay)
																.toLocaleString());
								$('.price-changes-percent')
										.text(
												'▼'
														+ (((lastCloseValue - lastCloseValuePreviousDay) / lastCloseValuePreviousDay) * 100)
																.toFixed(2));
								$('.price-changes').css('color', 'blue');
								$('.price-changes-percent')
										.css('color', 'blue');
								$('.last-close-value').css('color', 'blue');
								$('#price-change-box').css('background-color',
										'#ECF3FD');
							}
						}
					},
					error : function(xtr, status, error) {
						alert(xtr + ':' + status + ':' + error);
					},
				});
	}
	// 네이버 뉴스 api 호출
	$
			.ajax({
				type : 'GET',
				url : '/ehr/BLUEOCEAN/doNaverSearch.do',
				asyn : 'true',
				dataType : 'html',
				data : {
					keyword : $('#keyword').val(),
				},
				success : function(data) {
					let parsedJson = JSON.parse(data);
					let parsedItems = parsedJson.items;
					console.log(parsedItems);
					// keyword로 불러온 데이터에서 3개 항목에 대해서만 html에 출력
					let newsHtml = '';
					newsHtml += "<h5 style='font-weight:bold;'>"
							+ $('#keyword').val() + ' 뉴스</h5>';
					newsHtml += "<div class='naver-news'><div class='news-image-container'></div><div class='news-text-container'><a href='" +
                    parsedItems[0].link +
                    "' target='_blank'>"
							+ parsedItems[0].title
							+ '</a><p>'
							+ parsedItems[0].description + '</p></div></div>';
					newsHtml += "<div class='naver-news'><div class='news-image-container'></div><div class='news-text-container'><a href='" +
                    parsedItems[1].link +
                    "' target='_blank'>"
							+ parsedItems[1].title
							+ '</a><p>'
							+ parsedItems[1].description + '</p></div></div>';
					newsHtml += "<div class='naver-news'><div class='news-image-container'></div><div class='news-text-container'><a href='" +
                    parsedItems[2].link +
                    "' target='_blank'>"
							+ parsedItems[2].title
							+ '</a><p>'
							+ parsedItems[2].description + '</p></div></div>';
					$('#news-container').append(newsHtml);
				},
				error : function(data) {
					//실패시 처리
					console.log('error:' + data);
				},
			});
</script>
</html>