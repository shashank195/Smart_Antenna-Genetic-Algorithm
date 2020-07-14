import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import *

plt.title("Attenuation produced at 20deg elevation angle,as function of snow depth for wet snow on good earth and at various antenna height upto 7.5m (X/4) at 10Mhz ")
plt.xlabel('Snow Depth (in meters)')
plt.ylabel('Attenuation at 20deg elevation(bB)')

x1 = np.array([0, 0.5, 1, 2, 2.3])
y1 = np.array([0, 1.5, 3, 6, 8])
plt.plot(x1, y1)

x2 = np.array([0, 1, 2, 3, 4])
y2 = np.array([0, 2, 4, 6, 9])
plt.plot(x2, y2)

x3 = np.array([0, 1, 2, 3, 4])
y3 = np.array([0, 1.75, 3.75, 5.75, 8.75])
plt.plot(x3, y3)


plt.show()
