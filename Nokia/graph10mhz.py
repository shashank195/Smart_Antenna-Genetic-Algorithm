import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import *

plt.title("Attenuation produced by 1m of snow for 5m base fed vertical antenna at 10Mhz frequency for dry and wet snow ")
plt.xlabel('Elevation angle (deg)')
plt.ylabel('Attenuation introduced by 1mtr of snow (db)')

x1 = np.array([2,4,5,5.5,6,8,10,11,15,30])
y1 = np.array([8,4,3,2.8,2.6,1.6,1,1,1,1])
plt.plot(x1, y1, label='Dry snow')

x2 = np.array([2,3,4,5,8,10,13,15,20,25,30])
y2 = np.array([18,16,13.5,11,6,5,4.2,4,4,4,4]) 
plt.plot(x2, y2, label='Wet snow')


plt.text(24, 1.4, 'Dry snow')
plt.text(24, 4.4, 'Wet snow')
plt.text(15, 12, 'Conducting ground screen')
plt.text(32, 18, '© Robert W. Jenkins-IEEE Signal processing letters,Sept 1973')

plt.show()
