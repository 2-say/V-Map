package ParkLab.VMap;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

@SpringBootApplication
public class VMapApplication {

	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(VMapApplication.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(VMapApplication.class, args);
	}

}
