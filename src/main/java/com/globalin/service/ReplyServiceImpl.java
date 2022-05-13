package com.globalin.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.globalin.domain.Criteria;
import com.globalin.domain.ReplyPage;
import com.globalin.domain.ReplyVO;
import com.globalin.mapper.BoardMapper;
import com.globalin.mapper.ReplyMapper;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Autowired
	private ReplyMapper mapper;

	private Logger log = LoggerFactory.getLogger(ReplyServiceImpl.class);

	@Autowired
	private BoardMapper bMapper;
	// 댓글 등록 하는 부분
	// tbl_reply 에 댓글 insert + tbl_board 에 댓글수 update
	@Override
	public int register(ReplyVO vo) {
		log.info("register... : " + vo);
		
		
        bMapper.updateReplyCnt(vo.getBno(), 1);
		
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(int rno) {
		log.info("get... : " + rno);

		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		log.info("modify... : " + vo);

		return mapper.update(vo);
	}

	@Override
	public int remove(int rno) {
		log.info("remove... : " + rno);

		ReplyVO vo = mapper.read(rno);
		
		bMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}

	// 댓글 리스트 가져오는 메소드
	@Override
	public List<ReplyVO> getList(Criteria cri, int bno) {
		log.info("get reply list... : " + bno);
		// 이제 리스트가 아니라 replyPage를 가져다 주도록 변경

		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPage getListPage(Criteria cri, int bno) {
		ReplyPage page = new ReplyPage();
		
		log.info("cri : " + cri);
		
		// 이 페이지 안에는 댓글 개수, 댓글 리스트가 들어가야 된다.
		page.setReplyCnt(mapper.getCountByBno(bno));
		page.setList(mapper.getListWithPaging(cri, bno));
		return page;
	}

}
