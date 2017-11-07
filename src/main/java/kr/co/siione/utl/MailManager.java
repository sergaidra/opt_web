package kr.co.siione.utl;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import kr.co.siione.utl.egov.EgovProperties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MailManager {
	private static final Logger LOGGER = LoggerFactory.getLogger(MailManager.class);

	private String id = EgovProperties.getProperty("mail.smtp.auth.id");
	private String passWd = EgovProperties.getProperty("mail.smtp.auth.passwd");
	private String fromEmail = EgovProperties.getProperty("mail.from.email");
	private String fromName = EgovProperties.getProperty("mail.from.name");

	/**
	 * 메일발송
	 * @param subject
	 * @param content
	 * @param to
	 * @param attachMap : 발신자 정보 이미지 정보를 가지고 온다.
	 * @return
	 */
	public boolean sendMail(String subject, String content, String to, Map<String, Object> attachMap){
		boolean result = false;
		boolean debug = false;
		
		Properties props = new Properties();
		props.put("mail.transport.protocol", EgovProperties.getProperty("mail.transport.protocol"));
		props.put("mail.smtp.starttls.enable", EgovProperties.getProperty("mail.smtp.starttls.enable"));
		props.put("mail.smtp.host", EgovProperties.getProperty("mail.smtp.host"));
		props.put("mail.smtp.auth", EgovProperties.getProperty("mail.smtp.auth"));
		props.put("mail.smtp.port", EgovProperties.getProperty("mail.smtp.port"));
		
		//ssl 적용
		//props.put("mail.smtp.socketFactory.port", EgovProperties.getProperty("mail.smtp.socketFactory.port"));
		//props.put("mail.smtp.socketFactory.class", EgovProperties.getProperty("mail.smtp.socketFactory.class"));

		Authenticator auth = new SMTPAuthenticator();

		//session 생성 및  MimeMessage생성
		Session session = Session.getDefaultInstance(props, auth);
		session.setDebug(debug); //?

		MimeMessage msg = new MimeMessage(session);
		StringBuilder sbContent = new StringBuilder();

		try{
			InternetAddress addressFrom = new InternetAddress(fromEmail, fromName, "UTF-8");
			
			// 이메일 발신자
			msg.setFrom(addressFrom);
			// 이메일 수신자
			InternetAddress addressTo = new InternetAddress(to);
			msg.setRecipient(Message.RecipientType.TO, addressTo);
			//msg.setSubject(new String(subject.getBytes("UTF-8")));
			msg.setSubject(subject);
			msg.setHeader("Content-Transfer-Encoding", "quoted-printable");

			MimeMultipart multipart = new MimeMultipart("related");
			BodyPart messageBodyPartContent = new MimeBodyPart();
			sbContent.append("<div>");
			sbContent.append(content);

			// 내용에 이미지 포함
			int htmlImgCnt = 1;
			int imagesSize = ((List<Map<String, Object>>)attachMap.get("images")).size();
			for(int i=0; i < imagesSize; i++){
				sbContent.append("<img src=\"cid:image"+htmlImgCnt+"\">");
				sbContent.append("<br>");
				htmlImgCnt++;
			}
			
			sbContent.append("</div>");
			messageBodyPartContent.setContent(sbContent.toString(), "text/html; charset=UTF-8");
			multipart.addBodyPart(messageBodyPartContent);

			// 첨부파일
			int imageCnt = 1;
			for(Map<String, Object> imageMap : (List<Map<String, Object>>)attachMap.get("images")){
				BodyPart messageBodyPart = new MimeBodyPart();
				DataSource fds = new FileDataSource(String.valueOf(imageMap.get("imgPath"))); //첨부파일로 이미지 지정 방법
				messageBodyPart.setDataHandler(new DataHandler(fds));
				messageBodyPart.setFileName(MimeUtility.encodeText(fds.getName(), "EUC-KR", "B"));				
				messageBodyPart.setHeader("Content-ID","<image"+imageCnt+">");
				multipart.addBodyPart(messageBodyPart);
				imageCnt++;
			}
			
			msg.setContent(multipart);
			Transport.send(msg);
			result = true;
		}catch (AddressException ae) {
			LOGGER.error(ae.getMessage(), ae, ae.getStackTrace());
			result = false;
			ae.printStackTrace();
		}catch (MessagingException me) {
			LOGGER.error(me.getMessage(), me, me.getStackTrace());
			result = false;
			me.printStackTrace();
		} catch (UnsupportedEncodingException uee) {
			LOGGER.error(uee.getMessage(), uee, uee.getStackTrace());
			result = false;
			uee.printStackTrace();
		}

		return result;
	}

	public void sendMailHtmlFormat(){
		//필요한 경우 개발예정
	}

	/**
	 * 구글 사용자 메일 계정 아이디/패스 정보
	 */
	private class SMTPAuthenticator extends javax.mail.Authenticator {
		@Override
		public PasswordAuthentication getPasswordAuthentication() {
			String username = id;
			String password = passWd;
			return new PasswordAuthentication(username, password);
		}
	}
}
