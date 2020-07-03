%===============SMART ANTENNA===============
%Codigo para calucular array factor de uma antena inteligente utilizando
%algoritmo genetico para selecionar melhor combinacao de fases para um
%sinal de incidencia conhecida.

clc
clear all
close all
format compact

%numero de elementos (antenas) lineares
N = 7;
%distancia entre elementos (em comprimento de onda)
d=0.5;

%direcao thetha zero (caso todos elementos estejam em fase)
%90 para broadside e 0 para endfire
%thetha_zero=90;

%para algoritmo genetico as fases de cada elemento serao diferentes e entre
%0 e 90 cada uma delas
%gerar uma matriz contendo diversos individuos aleatorios

%tamanho de inicializacao
individuos = 25;

thetha_zero=zeros(N,individuos);
for indiv = 1:individuos
    for n=1:N
        thetha_zero(n,indiv)=randi([0,180]);
    end
end

%amplitude do sinal
%An=1;

%inicializando AF nulo
AF=zeros(individuos,360);

%calcula array factor para cada individuo
for i=1:individuos
    AF(i,:)=ArrayFactor(d,N,thetha_zero(:,i));
end


%DIRECAO DE INCIDENCIA

%FIXO
%DDI=60;
%thetha_inc=deg2rad(DDI);

%direcao do raio de incidencia (aleatorio)
DDI=(randi([0,180]));
thetha_inc=deg2rad(DDI);


%para melhor visualizacao deixa do mesmo tamanho de AF
R = max(AF(1));
for i=2:individuos
    R_ = max(AF(i));
    if R_ > R
        R = R_;
    end
end
%converte para complexo
complx_inc = R.*exp(1i*thetha_inc);
figure(1)
compass(complx_inc,'g')
hold on

thetha=[1:1:360];
thetha=deg2rad(thetha);

%desenha os n elementos um em cima do outro (fica poluido!)
figure(1)
for i=1:individuos
    polar(thetha,AF(i,:))
    hold on
end
title('Indivíduos da primeira geração')
legend('Direção do raio de incidência','Location','southoutside')

%pegar melhores valores individuos
best1=AF(1,DDI);
index1=1;
bestAF1=AF(1,:);
%Seleciona o melhor
for i=2:individuos
    if best1<AF(i,DDI)
        best1=AF(i,DDI);
        bestAF1=AF(i,:);
        index1=i;
    end
end
%seleciona o segundo melhor
best2=AF(1,DDI);
index2=1;
bestAF2=AF(i,:);
for i=2:individuos
    if best2<AF(i,DDI) && i ~= index1
        best2=AF(i,DDI);
        bestAF2=AF(i,:);
        index2=i;
    end
end

%grafico contendo apenas os 2 melhores da primeira geracao
figure(2)
compass(complx_inc,'g')
hold on
b1 = polar(thetha,bestAF1,'b');
b2 = polar(thetha,bestAF2,'b');
set(b1, 'linewidth',1)
set(b2, 'linewidth',1)


%seleciona as caracterisca dos melhores para herdar
p1=thetha_zero(:,index1)';
p2=thetha_zero(:,index2)';

%Definir as regras de cruzamento para gerar a populacao da proxima geracao
%Possibilidades:
%-criar combinacoes com as caracteristicas de cada um
%-Utilizar media deles
%-Aleatorio entre os dois valores

%Teste com crossover aleatorio
%gera valores binarios aleatorios para heranca
xover =(randi([0 1],N,individuos))';
%remove repeticoes (para populacoes grandes acaba reduzindo muito)
xover = unique(xover,'rows')';
%faz multiplicacao dos pais pelo crossover dando origem a segunda geracao
L=length(xover);
for l=1:L
    child_prt1(:,l)=p1'.*xover(:,l);
    child_prt2(:,l)=p2'.*~xover(:,l);
end
child=child_prt1+child_prt2;

%repetir todo procedimento novamente (TRANSFORMAR EM FUNCAO O PROCEDIMENTO
%PARA OTIMIZAR AS INTERACOES)
individuos = L;
thetha_zero=child;

AF2=zeros(individuos,360);
for i=1:individuos
    AF2(i,:)=ArrayFactor(d,N,thetha_zero(:,i));
end

%pegar melhores valores individuos
best1_2=AF2(1,DDI);
index1_2=1;
bestAF1_2=AF2(1,:);
%Seleciona o melhor
for i=2:individuos
    if best1_2<AF2(i,DDI)
        best1_2=AF2(i,DDI);
        bestAF1_2=AF2(i,:);
        index1_2=i;
    end
end



%seleciona o segundo melhor
best2_2=AF2(1,DDI);
index2_2=1;
bestAF2_2=AF2(1,:);
for i=2:individuos
    if best2_2<AF2(i,DDI) && i ~= index1_2 && AF2(i,DDI)~= best1_2
        best2_2=AF2(i,DDI);
        bestAF2_2=AF2(i,:);
        index2_2=i;
    end
end

%plotar em cima dos melhores anteriores para visualizar a melhora
figure(2)
hold on
b3 = polar(thetha,bestAF1_2, 'r');
hold on
b4 = polar(thetha,bestAF2_2, 'r');
title('Melhores soluções')
legend('Direção do raio de incidencia','Primeiro melhor','Segundo melhor','Primeiro melhor depois do cruzamento','Segundo melhor depois do cruzamento','Location','southoutside')
set(b3, 'linewidth',2)
set(b4, 'linewidth',2)

figure(3)
compass(complx_inc,'g')
hold on
for i=1:individuos
    polar(thetha,AF2(i,:))
end
title('Indivíduos da segunda geração')
legend('Direção do raio de incidência','Location','southoutside')
%aparentemente realizando mais interacoes nao apresentara muito ganho ja
%que uma populacao grande garante variedade suficiente para encontrar uma
%solucao boa para o problema

%comparacao de ganho
figure(4)
interacoes=[1 2];
plot(interacoes,[best1 best1_2],'b')
hold on;
plot(interacoes, [best2 best2_2],'r')
title('Comparação de ganho entre primeira e segunda geração')
legend('Primeiro melhor','Segundo melhor')

%realizando diversos testes poucos apresentaram aumento no ganho e quando
%apresenta a melhora eh pouco significante ->isto justifica o uso de poucas
%interacoes

%======ESTUDO DA MELHORIA DO SISTEMA======

DirTx = DDI 
%difinir uma direcao de interferencia 
DirInt = (randi([1,180]))

GanhoTx = bestAF1_2(DDI)
GanhoInt = bestAF1_2(DirInt)

%======ESTUDO DA FORMULA DE FRIIS========= 

%distancia em metros entre Rx e Tx
dist=(1:1:5000);
%Potencia Transmitida em Watts
Pt=1;
%Ganho Receptor (0dBi) Db em relacao antena isotropica
Gr=1;
%Ganho de Transmissor acima
%Comprimento de onda de operacao (4G) em Hz
lambda=1/2.5E9;
%A formula de Friis encontra a potencia recebida
Pr=Pt*Gr*GanhoTx*(lambda./(4*pi*dist)).^2;

%figure(5)
%semilogy(dist,Pr)

%title('Formula de Friis para o sistema')
%legend('Potencia Recebida (W) pela distancia (metros)')

%melhoras para o projeto:
%-considerar interferencia e tentar minimizar esta
%-considerar multiplos usuarios e tentar maximizar estes
%-realizar comparacoes com antenas omnidirecionais
%-estudo dessa aplicacao em comunicacoes moveis
%-dentre outras aplicacoes
