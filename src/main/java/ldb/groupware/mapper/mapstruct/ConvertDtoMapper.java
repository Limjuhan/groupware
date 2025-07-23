package ldb.groupware.mapper.mapstruct;


import ldb.groupware.domain.Faq;
import ldb.groupware.domain.FormAnnualLeave;
import ldb.groupware.dto.board.FaqFormDto;
import ldb.groupware.dto.draft.DraftFormDto;
import org.mapstruct.Mapper;

import java.sql.Time;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@Mapper(componentModel = "spring")
public interface ConvertDtoMapper {

	public FaqFormDto toFaqFormDto(Faq faq);

	public Faq toFaq(FaqFormDto faqFormDto);
	
	default Time map(String timeStr) {
	    if (timeStr == null) return null;
    	// "10:00" → "10:00:00"
    	LocalTime time = LocalTime.parse(timeStr, DateTimeFormatter.ofPattern("H:mm[:ss]"));
	    	 
	    return Time.valueOf(time);
	}
	
}
