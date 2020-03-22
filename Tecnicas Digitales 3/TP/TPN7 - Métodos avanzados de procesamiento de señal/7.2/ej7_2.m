%Guia 7, Ejercicio 2
%5R2; 24-10-19 
%Amaya, Lamas, Navarro, Veron

close all;
clear all;
clc;
N_fft = 1024;
delay=-300;

%PUNTO 2.1
[signal, fs] = audioread('numeros.wav'); 
%fs vale 44100Hz
info = audioinfo('numeros.wav'); %obtengo la informacion de la se�al de audio; "info" es una estructura con todos los datos del audio
figure()
pwelch(signal, 1024, 512, 1024, fs, 'centered') %grafico el espectro de la se�al de audio original
title('Se�al original.')
legend('Espectro de la se�al original.')

%PUNTO 2.1.1
%como la frecuencia de corte del filtro se pide que sea al menos menor que la mitad de la frecuencia de muestreo, se establece en 10KHz o 0.4535
f_corte = 10000; %frecuecnia de corte 10KHz
AB = 100; %ancho de banda de transicion, defino este ancho de banda; lo hago que sea bien abrupto la ca�da
taps = 300; %defino 300 coeficientes como repuesta al impulso

h_pb = filtro_pasa_bajos(fs, f_corte, AB, taps); %por medio de la funcion se crea el filtro
graf_respuesta(h_pb, N_fft)
title('Respuesta en frecuencia del filtro pasa bajos.')
legend('Espectro pasa bajos.')

signal_filtrado = filter(h_pb, 1, signal); %se aplica el filtro pasa bajos a la se�al de audio para limitar las frecuencias superiores
%signal_demod_filtrado = filter( h_pb, 1, signal_demod); %se aplica e filtro pasa bajos a la se�al de audio para eliminar las frecuencias imagenes

figure()
pwelch(signal_filtrado, 1024, 512, 1024, fs, 'centered') %se grafica la respuesta espectral de la se�al filtrada
title('Se�al original filtrada.')
legend('Espectro de la se�al filtrada con pasa bajos.')

%PUNTO 2.1.2
[signal_cos frec_cos]= signal_coseno(fs, info.TotalSamples, 0, 1); %llamo a la funcion para crear la se�al coseno, que devuelve los valores del coseno y su frecuencia
figure()
pwelch(signal_cos, 1024, 512, 1024, fs, 'centered') %grafico la respuesta del coseno, son dos impulsos en -11.025KHz y +11.025KHz(-0.5 y +0.5)
legend('Espectro de la se�al coseno.')
%para la modulacion, se multiplico en el tiempo la se�al de audio con el coseno creado
modulado = signal .* signal_cos'; %para poder multiplicarlos muestra a muestra, "signal" es una matriz columna, y "signal_cos" es matriz fila, por lo tanto a este ultimo le hago la transpuesta "'"
%sound(modulado, fs) %al escucharse esto, se puede percibir muy agudo el audio(casi no se escucha)
figure()
pwelch(modulado, 1024, 512, 1024, fs, 'centered') %se grafica e espectro de la se�al modulada
legend('Espectro de la se�al modulada.')


%PUNTO 2.1.3
%se crea el filtro pasa altos, con frecuencia de corte de 11.025KHz o 0.5
h_pa = filtro_pasa_altos(fs, 11025, AB, taps); %por medio de la funcion se crea el filtro
graf_respuesta(h_pa, N_fft)
title('Respuesta en frecuencia del filtro pasa altos.')
legend('Espectro pasa altos.')

modulado_filtrado = filter(h_pa, 1, modulado); %se aplica e filtro a la se�al modulada
figure()
pwelch(modulado_filtrado, 1024, 512, 1024, fs, 'centered') %se grafica e espectro de la se�al modulada
legend('Espectro de la se�al modulada filtrada con pasa altos.')


%PUNTO 2.1.4
%se crea otro coseno, pero con una ligera variaci�n en su frecuencia
[signal_cos frec_cos]= signal_coseno(fs, info.TotalSamples, delay, 1); %el tercer argumento de esta funci�n, controla el desplazamiento + o - en frecuencia en Hz
figure()
pwelch(signal_cos, 1024, 512, 1024, fs, 'centered') %se grafica e espectro de la se�al coseno con frecuencia ligeramente distinta
legend('Espectro de la se�al coseno con delta f.')

signal_demod = modulado_filtrado .* signal_cos'; %se hace la demodulaci�n, con el producto de signal_cos por la se�al modulado_filtrado
figure()
pwelch(signal_demod, 1024, 512, 1024, fs, 'centered') %se grafica e espectro de la se�al demodulada
legend('Espectro de la se�al modulada.')
%sound(signal_demod, fs)


%PUNTO 2.1.5
%signal_demod_filtrado = filter( h_pb, 1, signal_demod); %se aplica e filtro pasa bajos a la se�al de audio para eliminar las frecuencias imagenes
signal_demod_filtrado = filter(filtro_pasa_bajos(fs, 11025, AB, taps), 1, signal_demod); %se aplica e filtro pasa bajos a la se�al de audio para eliminar las frecuencias imagenes
sound(signal_demod_filtrado, fs) %se reproduce el audio de la se�al demodulada y filtrada, se debe escuchar el cambio del tono
%audiowrite('agudo.wav',signal_demod_filtrado,fs)

figure()
pwelch(signal_demod_filtrado, 1024, 512, 1024, fs, 'centered') %se grafica el espectro de la se�al demodulada y filtrada
legend('Espectro de la se�al demodulada y filtrada.')

