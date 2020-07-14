import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import *

plt.title("Attenuation produced by 1m of snow for 5m base fed vertical antenna at 5Mhz frequency for dry and wet snow ")
plt.xlabel('Elevation angle (deg)')
plt.ylabel('Attenuation introduced by 1mtr of snow (db)')

x1 = np.array([1,2,3,4,5,10,15,20,25,30])
y1 = np.array([3.8,2.7,1.6,1.3,1,1,1,1,1,1])
plt.plot(x1, y1, label='Dry snow')

x2 = np.array([2,5,6,7,10,15,20,25,30])
y2 = np.array([13,8,7,6,4.7,4,4,4,4]) 
plt.plot(x2, y2, label='Wet snow')


plt.text(24, 1.3, 'Dry snow')
plt.text(24, 4.3, 'Wet snow')
plt.text(15, 10, 'Conducting ground screen')
plt.text(32, 13, '© Robert W. Jenkins-IEEE Signal processing letters,Sept 1973')

plt.show()
