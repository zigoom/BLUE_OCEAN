package com.pcwk.ehr.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.pcwk.ehr.cmn.PcwkLogger;
import com.pcwk.ehr.cmn.DTO;
import com.pcwk.ehr.domain.BoardVO;


/**
 * 1.doSave
 * 2.doDelete
 * 3.doUpdate
 * 4.doUpdate
 * 5.doSelectOne
 * 6.doRetrieve
 * 
 * @author user
 *
 */

@Repository
public class BoardDaoImpl implements BoardDao, PcwkLogger {
    final String NAMESPACE = "com.pcwk.ehr.dao.BoardDao";
    final String DOT = ".";

    @Autowired
    SqlSessionTemplate sqlSessionTemplate;  //DB 객체 생성

    @Override
    public int doSave(BoardVO inVO) throws SQLException {
        // Board 테이블에 데이터를 저장하는 로직을 구현하세요.
        // 예를 들어, sqlSessionTemplate.insert(NAMESPACE + DOT + "doSave", inVO); 등
        // 적절한 MyBatis 메서드를 사용하여 데이터를 저장할 수 있습니다.
        // 구현이 완료되면 저장된 데이터의 개수를 반환합니다.
        return 0;
    }

    @Override
    public int doDelete(BoardVO inVO) throws SQLException {
        // Board 테이블에서 데이터를 삭제하는 로직을 구현하세요.
        // 예를 들어, sqlSessionTemplate.delete(NAMESPACE + DOT + "doDelete", inVO); 등
        // 적절한 MyBatis 메서드를 사용하여 데이터를 삭제할 수 있습니다.
        // 구현이 완료되면 삭제된 데이터의 개수를 반환합니다.
        return 0;
    }

    @Override
    public int doUpdate(BoardVO inVO) throws SQLException {
        // Board 테이블의 데이터를 수정하는 로직을 구현하세요.
        // 예를 들어, sqlSessionTemplate.update(NAMESPACE + DOT + "doUpdate", inVO); 등
        // 적절한 MyBatis 메서드를 사용하여 데이터를 수정할 수 있습니다.
        // 구현이 완료되면 수정된 데이터의 개수를 반환합니다.
        return 0;
    }

    @Override
    public BoardVO doSelectOne(BoardVO inVO) throws SQLException {
        // Board 테이블에서 하나의 데이터를 조회하는 로직을 구현하세요.
        // 예를 들어, sqlSessionTemplate.selectOne(NAMESPACE + DOT + "doSelectOne", inVO); 등
        // 적절한 MyBatis 메서드를 사용하여 데이터를 조회할 수 있습니다.
        // 조회된 데이터를 BoardVO 객체로 변환하여 반환합니다.
        return null;
    }

    @Override
    public int doRetrieveCount(BoardVO inVO) throws SQLException {
        return sqlSessionTemplate.selectOne(NAMESPACE + DOT + "doRetrieveCount", inVO);
    }

    @Override
    public List<BoardVO> doRetrieve(BoardVO inVO) throws SQLException {
    	System.out.println("DAOIMPL구역");
		System.out.println("no   : " + inVO.getPageNo());	
		System.out.println("word : " +  inVO.getSearchWord());
        return sqlSessionTemplate.selectList(NAMESPACE + DOT + "doRetrieve", inVO);
    }


    

}