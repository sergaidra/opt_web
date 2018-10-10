package kr.co.siione.gnrl.main.vo;

import java.util.ArrayList;
import java.util.List;

public class ScheduleDateVo {
	private String date;
	private List<ScheduleTimeVo> lstTime = new ArrayList<ScheduleTimeVo>();
	
	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public List<ScheduleTimeVo> getLstTime() {
		return lstTime;
	}

	public void setLstTime(List<ScheduleTimeVo> lstTime) {
		this.lstTime = lstTime;
	}
	
	public static void addTime(List<ScheduleDateVo> lst, String dt, String beginTime, String endTime, String text) {
		for(int i = 0; i < lst.size(); i++) {
			ScheduleDateVo dvo = lst.get(i);
			if(dt.equals(dvo.getDate())) {
				Boolean isMorning = false;
				Boolean isAfternoon = false;
				Boolean isNight = false;
				if(beginTime.compareTo("12:00") < 0) {
					isMorning = true;
				}
				if(beginTime.compareTo("12:00") >= 0 && beginTime.compareTo("18:00") < 0) {
					isAfternoon = true;
				}
				if(beginTime.compareTo("18:00") >= 0) {
					isNight = true;
				}
				
				if(endTime.compareTo("12:00") <= 0) {
					isMorning = true;
				}
				if(endTime.compareTo("12:00") > 0 && beginTime.compareTo("18:00") <= 0) {
					isAfternoon = true;
				}
				if(endTime.compareTo("18:00") > 0) {
					isNight = true;
				}
				
				if(isMorning == true) {
					ScheduleTimeVo tvo = null;
					for(int j = 0; j < dvo.getLstTime().size(); j++) {
						if("morning".equals(dvo.getLstTime().get(j).getMode())) {
							tvo = dvo.getLstTime().get(j);
						}
					}
					if(tvo != null) {
						tvo.setTime(beginTime);
						tvo.setText(text);
					}
				}
				
				if(isAfternoon == true) {
					ScheduleTimeVo tvo = null;
					for(int j = 0; j < dvo.getLstTime().size(); j++) {
						if("afternoon".equals(dvo.getLstTime().get(j).getMode())) {
							tvo = dvo.getLstTime().get(j);
						}
					}
					if(tvo != null) {
						tvo.setTime(beginTime);
						tvo.setText(text);
					}
				}

				if(isNight == true) {
					ScheduleTimeVo tvo = null;
					for(int j = 0; j < dvo.getLstTime().size(); j++) {
						if("night".equals(dvo.getLstTime().get(j).getMode())) {
							tvo = dvo.getLstTime().get(j);
						}
					}
					if(tvo != null) {
						tvo.setTime(beginTime);
						tvo.setText(text);
					}
				}
			}
		}
	}
	
	public static void addTime(List<ScheduleDateVo> lst, ScheduleTimeVo vo) {
		for(int i = 0; i < lst.size(); i++) {
			ScheduleDateVo dvo = lst.get(i);
			if(vo.getDate().equals(dvo.getDate())) {
				dvo.lstTime.add(vo);
			}
		}
	}
	
	public static void setTable(List<ScheduleDateVo> lst) {
		Boolean isStart = false;
		int idxStart = -1;
		for(int i = 0; i < lst.size(); i++) {
			ScheduleDateVo dvo = lst.get(i);
			for(int j = 0; j < dvo.getLstTime().size(); j++) {
				ScheduleTimeVo tvo = dvo.getLstTime().get(j);
				if("start".equals(tvo.getMode())) {
					isStart = true;
					idxStart = i;
					
					if(tvo.getTime().compareTo("07:00") < 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "breakfast"));
					if(tvo.getTime().compareTo("08:00") < 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "morning"));
					if(tvo.getTime().compareTo("12:00") < 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "lunch"));
					if(tvo.getTime().compareTo("13:00") < 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "afternoon"));
					if(tvo.getTime().compareTo("18:00") < 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "dinner"));
					if(tvo.getTime().compareTo("19:00") < 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "night"));
				}
				if("end".equals(tvo.getMode())) {
					if(tvo.getTime().compareTo("08:00") > 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "breakfast"));
					if(tvo.getTime().compareTo("12:00") > 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "morning"));
					if(tvo.getTime().compareTo("13:00") > 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "lunch"));
					if(tvo.getTime().compareTo("18:00") > 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "afternoon"));
					if(tvo.getTime().compareTo("19:00") > 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "dinner"));
					if(tvo.getTime().compareTo("23:00") > 0)
						dvo.lstTime.add(new ScheduleTimeVo(dvo.getDate(), "night"));
					return;
				}
			}

			if(isStart == true && idxStart != i) {
				ScheduleTimeVo tvo1 = new ScheduleTimeVo(dvo.getDate(), "breakfast");
				ScheduleTimeVo tvo2 = new ScheduleTimeVo(dvo.getDate(), "morning");
				ScheduleTimeVo tvo3 = new ScheduleTimeVo(dvo.getDate(), "lunch");
				ScheduleTimeVo tvo4 = new ScheduleTimeVo(dvo.getDate(), "afternoon");
				ScheduleTimeVo tvo5 = new ScheduleTimeVo(dvo.getDate(), "dinner");
				ScheduleTimeVo tvo6 = new ScheduleTimeVo(dvo.getDate(), "night");
				dvo.lstTime.add(tvo1);
				dvo.lstTime.add(tvo2);
				dvo.lstTime.add(tvo3);
				dvo.lstTime.add(tvo4);
				dvo.lstTime.add(tvo5);
				dvo.lstTime.add(tvo6);
			}
		}
	}
}
