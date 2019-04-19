function BasicGA
tic
%% ��ʼ����ȷ��
DNA_SIZE=10;
POP_SIZE=100;
CROSS_RATE=0.8;
MUTATION_RATE=0.003;
N_GENERATIONS=300;
X_BOUND=[0,5];

%% ��ѭ��
%������ɢ���ȷֲ���pop����
pop=rand(POP_SIZE,DNA_SIZE)<0.5;
x=X_BOUND(1):(X_BOUND(2)-X_BOUND(1))/200:X_BOUND(2);

for i=1:N_GENERATIONS
    F_values=F(translateDNA(pop));
    %��ͼ
    clf;
    plot(x,F(x));
    hold on;
    scatter(translateDNA(pop), F_values, 'red', 'filled'); 
    title(sprintf('�� %d �ε������ʾ��ͼ', i));
    pause(0.05);
    
    fitness=get_fitness(F_values);
    pop_select=select(pop,fitness);
    pop_copy=pop_select;
    for num=1:POP_SIZE
        parent=pop_select(num,:);
        child=crossover(parent,pop_copy);
        child=mutate(child);
        popNew(num,:)=child;
    end
    pop=popNew;
end

%% F() ���غ���ֵ
    function y=F(x)
       y=sin(10*x).*x+cos(2*x).*x;
    end
%% get_fitness() ����һ���Ǹ�������Ӧ��ֵ
    function y=get_fitness(F_values)
        y=F_values+1e-3-min(F_values);
    end
%% translateDNS() ����DNA,�������Ʊ���Ϊʮ������
    function trans=translateDNA(pop)
        trans1=(pop*pow2(DNA_SIZE-1:-1:0).')';
        trans=trans1/(2^DNA_SIZE-1)*X_BOUND(2);
    end
%% select() ѡ����Ӧ�ȸߵ�DNA���У������µ���Ⱥ
    function pop_new=select(pop,fitness)
        p=fitness/sum(fitness);
        p_add=p(1);
        for j=2:POP_SIZE
            p_add(j)=p_add(j-1)+p(j);
        end
        for j=1:POP_SIZE
            select=find(p_add>rand);
            pop_new(j,:)=pop(select(1),:);
        end  
     end
%% crossover() ���游ĸ����
    function parent=crossover(parent,pop)
        if rand<CROSS_RATE
            i_NUM=unidrnd(POP_SIZE);
            cross_point=unidrnd(DNA_SIZE);
            for j_NUM=cross_point:DNA_SIZE
                parent(j_NUM)=pop(i_NUM,j_NUM);
            end
        end
    end
 
%% mutation() �������
    function child=mutate(child)
        for point=1:DNA_SIZE
            if rand<MUTATION_RATE
                if child(point)==0
                    child(point)=1;
                else
                    child(point)=0;
                end
            end
        end
    end


toc
end
