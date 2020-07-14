import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import *

plt.title("Attenuation produced by 1m of snow for 5m base fed vertical antenna at 20Mhz frequency for dry and wet snow ")
plt.xlabel('Elevation angle (deg)')
plt.ylabel('Attenuation introduced by 1mtr of snow (db)')

x1 = np.array([2,5,7,10,11,15,30])
y1 = np.array([12,6,3,1.2,1,1,1])
plt.plot(x1, y1, label='Dry snow')

x2 = np.array([2,3,4,5,6,10,11,13,15,20,25,30])
y2 = np.array([24,21,18,16,14,9.4,8.2,6.2,5,4.5,4.2,4]) 
plt.plot(x2, y2, label='Wet snow')


plt.text(24, 1.5, 'Dry snow')
plt.text(24, 5, 'Wet snow')
plt.text(32, 24, '© Robert W. Jenkins-IEEE Signal processing letters,Sept 1973')

plt.show()
