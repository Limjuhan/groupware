package ldb.groupware.dto.board;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PaginationDto {
	
	private String professorId;
	private int page;			// 클라이언트로부터 요청받은 페이지번호
	private int startPage;          // 클라이언트에 표시할 시작 페이지 번호
	private int endPage;			// 클라이언트에 표시할 마지막 페이지 번호
    private int totalRows;          // 총 데이터 수
    private int itemsPerPage = 10;  // 페이지당 로우 수(기본값:10)
    private int totalPages;         // 총 페이지 수
    private String search;   			// 검색 키워드 
    private String sortDirection;   	// 정렬방향
    private int startNum;//페이지조회시 시작할 지점



    public void calculatePagination() {
        if (totalRows <= 0) {
            totalRows = 0;
        }

        //(총게시물) 20개  / 10개(한페이지의 최대갯수) ==>  2 (최대페이지)
        this.totalPages = (int) Math.ceil((double) totalRows / itemsPerPage);

        if (this.totalPages == 0) {
            this.totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }



        int pageBlockSize = 5;
        startPage = ((page - 1) / pageBlockSize) * pageBlockSize + 1;
        endPage = Math.min(startPage + pageBlockSize - 1, totalPages);
        startNum = ((page - 1) * itemsPerPage) +1;
    }
    
}