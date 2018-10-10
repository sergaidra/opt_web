package kr.co.siione.gnrl.main.vo;

public class ScheduleTimeVo {
	private String date;
	private String time;
	private String text;
	private String mode;

	public ScheduleTimeVo(String date, String mode) {
		this.date = date;
		this.mode = mode;
	}
	
	public ScheduleTimeVo(String time, String text, String mode) {
		this.date = time.substring(0, 10);
		this.time = time.substring(11, 16);
		this.text = text;
		this.mode = mode;
	}
	
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getMode() {
		return mode;
	}
	public void setMode(String mode) {
		this.mode = mode;
	}

}
