# Готовый образ Chrome 106 версии
FROM selenoid/vnc:chrome_106.0
# Установка пользователя root
USER root


# Юзер под которым запускается контейнер
ARG USER_NAME=selenium
 
ADD dist/ /tmp/dist/
ADD cert/ /tmp/cert/

# Распаковать КриптоПро CSP 5
RUN tar -zxvf /tmp/dist/linux-amd64_deb.tgz -C /tmp/dist/
 
# Установка КриптоПро CSP 5
RUN /tmp/dist/linux-amd64_deb/install.sh

# для установки следующего пакета обязательно нужна библиотека libgtk2.0-dev
RUN apt-get update
RUN apt-get install -y libgtk2.0-dev

RUN dpkg -i /tmp/dist/linux-amd64_deb/cprocsp-rdr-gui-gtk-64_5.0.12600-6_amd64.deb


# Распаковать cades plugin
RUN tar -zxvf /tmp/dist/cades_linux_amd64.tar.gz -C /tmp/dist/
# Установить cades plugin
RUN dpkg -i /tmp/dist/cades_linux_amd64/cprocsp-pki-cades-64_2.0.14071-1_amd64.deb
RUN dpkg -i /tmp/dist/cades_linux_amd64/cprocsp-pki-plugin-64_2.0.14071-1_amd64.deb
 
# Проверка лицензии
RUN /opt/cprocsp/sbin/amd64/cpconfig -license -view
 
# переключаемся на "обычного" юзера перед установкой сертификатов
USER $USER_NAME
 
# установка корневого сертификата
#RUN echo o | /opt/cprocsp/bin/amd64/certmgr -inst -file /tmp/cert/root.cer -store uRoot
 
# установка личного сертификата. -pin <password> это пароль от закрытого ключа
RUN /opt/cprocsp/bin/amd64/certmgr -inst -file /tmp/cert/test12.cer -silent
 
# команда, для того чтобы убрать всплывающее окно - "лицензия истекает меньше чем через 2 месяца".
RUN /opt/cprocsp/sbin/amd64/cpconfig -ini '\local\KeyDevices' -add long LicErrorLevel 4
 
# переключаемся на суперюзера
USER root
 
# убираем alert "переход на новый алгоритм в 2019 году"
RUN sed -i 's/\[Parameters\]/[Parameters]\nwarning_time_gen_2001=ll:131907744000000000\nwarning_time_sign_2001=ll:131907744000000000/g' /etc/opt/cprocsp/config64.ini
 
# Добавляем адрес тестируемого приложения в доверенные.
RUN /opt/cprocsp/sbin/amd64/cpconfig -ini "\config\cades\trustedsites" -add multistring "TrustedSites" "http://<ip_sedd>/sedd"
 
# переключаемся на "обычного" юзера
USER $USER_NAME
