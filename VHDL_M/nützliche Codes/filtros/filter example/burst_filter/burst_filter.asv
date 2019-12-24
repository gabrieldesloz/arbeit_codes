clear;


fs = 15360;
N = 256;
bin = fs/N;
t1 = 0:1:(N-1);
t = t1/fs;
f = 60;
v= sin(2*pi*f*t);
V = fft(v);
V = abs(V);

plot(t1,V);

t = v;
v(10) = 10;

for i=3:1:length(v)
    if (v(i) < v(i-1))   % v(i) < v(i-1) here
          if (v(i) < v(i-2))   %   v(i) < v(i-2)     : v(i) the smallest
            if (v(i-1) < v(i-2))   %      v(i-1) < v(i-2)  : v(i) < v(i-1) < v(i-2)
              t(i) = v(i-1);
            else  %      v(i-2) <= v(i-1) : v(i) < v(i-2) <= v(i-1)
              t(i) = v(i-2);
            end;
          else  %   v(i) >= v(i-2)    : v(i-2) <= v(i) < v(i-1)
            t(i) = v(i);
          end;
     else                            % v(i-1) <= v(i) here
          if (v(i-1) < v(i-2))   %   v(i-1) < v(i-2)     : v(i-1) the smallest
            if (v(i) < v(i-2))   %     v(i) < v(i-2)   : v(i-1) <= v(i) < v(i-2)
              t(i) = v(i);
            else  %     v(i) >= v(i-2)  : v(i-1) < v(i-2) <= v(i)
              t(i) = v(i-2);
            end;
          else  %   v(i-2) <= v(i-1)    : v(i-2) <= v(i-1) <= v(i)
            t(i) = v(i-1);
          end;
      end;   
end;

T = fft(t);
T= abs(T);
plot(t1,v);
%plot(t1, v, t1,t);
grid;





