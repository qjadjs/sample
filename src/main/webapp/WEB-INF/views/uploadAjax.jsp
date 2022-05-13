<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
  .uploadResult {
      width : 100%;
      background-color : gray;
      
      
  }
  .uploadResult ul {
    display:flex;
    flex-flow: row;
    justify-content: center;
    align-items : center;
  }
  
  .uploadResult ul li {
    list-style : none;
    padding : 10px
    
  }
  
  .uploadResult ul li img {
    /* width : 20px; */
  }
  .bigPictureWrapper {
    position : absolute;
   display: none;
   justify-content: center;
   align-items: center;
   top: 0;
   width: 100%;
   height: 100%;
   background-color: gray;
   z-index: 100;
  }
  
  .bigPicture {
    position : relative;
    display : flex;
    justify-content: center;
    align-items: center;
  
  }
  .bigPicture img {
    width : 600px;
  }
  .uploadResult ul li span {
   color : white;
  } 
  
</style>
</head>
<body>
     <div class="uploadDiv">
       <input type="file" name="uploadFile" multiple>
     </div>
     <div class="uploadResult">
       <ul>
        
       </ul>
     </div>
     <button id="uploadBtn">파일 업로드</button>
     <div class="bigPictureWrapper">
       <div class="bigPicture">
       </div>
     </div>
     <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>

     <script>
     // 원본 이미지를 보여주는 함수
     // jquery 로드 안된 상황에서도 사용할수 있도록 밖에다가 작성
     function showImage(filePath) {
    	 // alert(filePath);
    	 $(".bigPictureWrapper").css("display" , "flex").show();
    	 
    	 // html코드로 img 태그를 삽입
    	 $(".bigPicture")
    	 .html("<img src='/display?fileName=" + encodeURI(filePath) + "'>" )
    	 .animate({width:'100%' , height:'100%'}, 1000);
    	 
    	 $(".bigPictureWrapper").on("click" , function(e) {
    		 // 이미지 크기만 0으로 줄이고
    		 $(".bigPicture").stop().animate({width: '0%' , height: '0%'}, 1000);
    		 
    		 // 1초후에 숨기기
    		 setTimeout(function () {
    			 $(".bigPictureWrapper").hide();
    		 }, 1000);
    	 })
     }
    	 $(".uploadResult").on("click" , "span" , function(e) {
    		
    		 // 삭제 대상 파일 
    		 let targetFile = $(this).data("file");
    		 // 삭제 대상 파일의 타입
    		 let type = $(this).data("type");
    		 
    		 $.ajax({
    			url : '/deleteFile',
    			type : 'POST',
    			data : {fileName : targetFile, type:type},
    			dataType : 'text',
    			success : function(result) {
    				alert(result);
    			}
    	 })
    	 
    	 })
     $(document).ready(function() {
    	 
    	 // 여기서 확장자 제한
    	 // exe , 압축파일 제한
    	 // 파일 크기 제한까지
    	 // 확장자를 검사하는 제일 간단한 방법 ==> string 함수를 이용해서
    	 // 파일 이름안에 exe ? zip ? alz? sh ? 이런것들이 포함되어 있는지 검사
    	 // includes
    	 // 또 다른 방법 ==> 표현식 (정규식)
    	 let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)");
    	 let maxSize = 5242880 ; //파일크기 5MB
    	 
    	 // 파일 선택 안한상태의 input 태그를 복사해놓고
    	 var cloneObj = $(".uploadDiv").clone();
    	 
    	 // 업로드 결과를 보여줄 div 태그 안에 ul 태그 찾아오기
    	 var uploadResult = $(".uploadResult ul");
    	 
    	 // 우리가 찾아온 ul 태그안에 업로드 한 파일들의 정보를 동적으로 생성하여 추가
    	 function showUploadedFile(uArr) {
    		 
    		 let uploadHtml = "";
    		 
    		 // 업로드 파일 한개 ==> <li> 태그 한개
    		 for(let i = 0; i< uArr.length; i++){
    			 
    			 if(uArr[i].image == false) {
    				 // 이미지 파일이 아닌 경우에
    				 // li 태그 앞에다가 파일 아이콘을 붙여 주겠습니다.
    				 let fileCallPath = encodeURIComponent("/" + uArr[i].uuid
    						 + "_" + uArr[i].fileName);
    				 
    				 uploadHtml += "<li>"
    					 + "<a href='/download?fileName=" + fileCallPath + "'>"
    					 + "<img src='/resources/img/attach.jpg'>"
    				 + uArr[i].fileName + "</a>"
    				 + "<span data-file=\'" + fileCallPath + "\' data-type='file' > x </span>"
    				 + "</li>";
    			 } else {
    		         // 이미지 파일 인 경우
    		         // img태그를 추가하는데 이거를 올린 이미지로
    			     // uploadHtml += "<li>" + uArr[i].fileName + "</li>";
    			     // 우리가 첨부파일을 이미지로 올리면
    			     // 원본파일 올리고, 추가로 썸네일 이미지가 생성됨
    			     // 여기서 사용할거는 섬네일 이미지
    			     // 섬네일 이미지는 파일이름
    			     // 업로드 경로 + s_ + uuid + 원래파일이름
    			     // 한글 이름이 문제가 될수도 있어서 encoding 처리를 해준다.
    			     let fileCallPath = encodeURIComponent("/s_" + uArr[i].uuid + "_" + uArr[i].fileName);
    			     
    			     let originPath = uArr[i].uuid + "_" + uArr[i].fileName;
                     originPath = originPath.replace(new RegExp(/\\/g), "/");
    			     
    			     uploadHtml += "<li>" 
    			     +"<a href=\"javascript:showImage(\'"+ originPath + "\')\">"
    			     // <a href="javascript:showImage(originPath)">
    			     +"<img src='/display?fileName=" + fileCallPath + "'></a><span data-file=\'" + fileCallPath + "\' data-type='image' > x </span></li>";
    			 }
    			 
    			 
    		 }
    		 // ul 태그 밑에 li 태그 붙이기
    		 uploadResult.append(uploadHtml);
    	 }
    	 // 파일을 검사하는 함수
    	 function checkFile(fileName, fileSize) {
    		 // 파일 크기 검사
    		 if(fileSize > maxSize) {
    			 alert("파일 최대 크기 초과");
    			 return false;
    		 }
    		 // 파일 확장자 검사 : 정규식과 파일 이름이 일치하는 패턴이면 false를 리턴
    		 if(regex.test(fileName)) {
    			 alert("구본우 바퀴벌레");
    			 return false;
    		 }
    		 // 두개 모두 통과 했다면 return true;
    		 return true;
    	 }
    	 
    	 
    	 
    	 $("#uploadBtn").on("click" , function(e) {
    		 // form 태그 없이 form 을 만들어서 보내는 방법
    		 let formData = new FormData();
    		 
    		 // input 태그 가져오기 
    		 let file = $("input[name='uploadFile']");
    		 
    		 // input 태그에서 file 가져오기
    		 let files = file[0].files;
    		 
    		 console.log(files);
    		 
    		 // formData에 파일 추가
    		 for(let i=0; i<files.length; i++) {
    			 
    			 // 파일 검사 중에 false가 나오면 파일 업로드를 중단시킨다.
    			 if(checkFile(files[i].name, files[i].size) == false){
    				 return false;
    			 }
    			 
    			 formData.append("uploadFile" , files[i]);
    		 }
    		 
    		 // input type="file" 초기화 준비
    		 // 초기화는 언제 ?? 파일 업로드요청 보내고 나서 성공하고 해야한다.
    				 
    		 
    		 // ajax 요청 보내기
    		 // processData , contentType 이 왜 false 인가???
    	     // contentType : application/json 
    	     // 우리가 파일을 실어서 보내는데 contentType이 file 형식으로 가야된다.
    	     // false로 넣어줘야 contentType 이 multipart로 설정되서 보내진다.
    	     // processData : 우리가 ajax 로 data 속성이
    	     // jquery 내부적으로 query string으로 변경을 해버린다. (데이터 처리)
    	     // 우리는 데이터 처리를 하지 말고 파일전송의 경우 파일의 데이터를 그대로 보내야 하기 때문에
    	     // 처리 하지 말라고 false 값을 준다.
    		 $.ajax({
    			url : "/uploadAjaxAction",
    			processData : false,
    			contentType : false,
    			data : formData,
    			type : "POST",
    			success : function(result) {
    				console.log(result);
    				
    				showUploadedFile(result);
    				
    				// 요청 보내고 나서 성공 하면 input file 초기화
    				$(".uploadDiv").html(cloneObj.html());
    			}
    		 }); // ajax end
    	 })
     })
     </script>
</body>
</html>