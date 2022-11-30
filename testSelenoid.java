import com.codeborne.selenide.Configuration;
import com.codeborne.selenide.WebDriverRunner;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;

import static com.codeborne.selenide.Selenide.open;
import static com.codeborne.selenide.Selenide.sleep;
import static javax.swing.UIManager.put;

public class TestSelenoid {

    @Test
    public void test() throws URISyntaxException, MalformedURLException {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--enable-extensions");
        options.addExtensions(new File("src/test/resources/1.2.8_0.crx"));
        options.addArguments("--no-sandbox");

        options.setCapability("sessionTimeout", "15m");
        options.setCapability("browserName", "chrome");
        options.setCapability("browserVersion", "selenoid_aaaaaaaa");

        var selenoidOpt = new HashMap<String, Object>() {
            {
                put("enableVNC", true);
            }
        };
        options.setCapability("selenoid:options", selenoidOpt);

        RemoteWebDriver rd = new RemoteWebDriver(new URI("http://<selenoidUrl>/wd/hub").toURL(), options);
        WebDriverRunner.setWebDriver(rd);

        open("https://www.cryptopro.ru/sites/default/files/products/cades/demopage/cades_bes_sample.html");
        sleep(50000);

    }
}
