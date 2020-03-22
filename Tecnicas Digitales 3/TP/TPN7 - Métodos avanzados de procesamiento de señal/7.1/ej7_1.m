%Guia 7, Ejercicio 1
%5R2; 24-10-19 
%Amaya, Lamas, Navarro, Veron

close all;
clear all;
clc;

N_fft = 1024;                                   %se define la resolucion a utilizar en la FFT

[signal, fs1] = audioread('Jahzzar_29400.wav'); %en el MatLab 2017 esta funcion equivale a wavread
%fs1= 29400Hz
fs2 = 44100;                                    %frecuencia de muestreo superior, a la que quiero llevar
figure()
pwelch(signal, 1024, 512, 1024, fs1)
legend('Espectro del audio.')

%la relaci�n de conversi�n la puedo obtener de la siguiente forma, ya que fs2 = fs1*L/M
rel_conv = fs2/fs1; %obtengo como valor 1.5, lo que en fraccion ser�a: 3/2=L/M, siendo L=3 y M=2
[L, M] = rat(rel_conv); %esta funci�n s�lo esta en MatLab, NO en Octave

signal_up = upsample(signal, L); %agrega L-1 ceros entre cada muestra de la se�al original
figure()
pwelch(signal_up, 1024, 512, 1024, L*fs1)
title('Espectro de la se�al "remuestreada".')
legend('Espectro se�al "upsamplig".')

%dise�o del filtro pasa bajos, lo hago mediante LMS
fm = fs1*L; %frecuencia de muestreo para el filtro
f_corte = fm/(2*L);
AB = 100; %ancho de banda de transicion, defino este ancho de banda; lo hago que sea bien abrupto la ca�da
taps = 300; %defino el numero de taps del kernel del filtro
h_pb = filtro_pasa_bajos(fm, f_corte, AB, taps);
graf_respuesta(h_pb, N_fft)
title('Respuesta en frecuencia del filtro pasa bajos.')
legend('Espectro pasa bajos.')

y_filtrado = filter(h_pb, 1, signal_up); %se aplica el filtro pasa bajos a la se�al sobremuestreada
figure()
pwelch(y_filtrado, 1024, 512, 1024, L*fs1)
title('Espectro de la se�al filtrada.')
legend('Espectro se�al filtrada con pasa bajos.')
%y_filtrado_sinL = y_filtrado;

y_filtrado = y_filtrado*L; 

signal_down = downsample(y_filtrado, M);
%signal_down_sinL = downsample(y_filtrado_sinL, M);
figure()
pwelch(signal_down, 1024, 512, 1024, fs1)
title('Espectro de la se�al "diezmada".')
legend('Espectro se�al filtrada.')

audiowrite('Jahzzar_44100.wav', signal_up, fs2) %
sound(signal_down, fs2) %luego de todo el procesado, se reproduce la se�al diezmada con una frecuencia de muestreo de 44100Hz

