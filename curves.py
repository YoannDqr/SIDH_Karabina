import utils


class ECurve:
	"""
	The curve is defined by the equation y^2 = x^3 + ax + b
	p is the modulo. Shall be a prime number as big as possible
	"""

	def __init__(self, a, b, p):
		self.a = utils.is_int(a)
		self.b = utils.is_int(b)
		self.p = utils.is_int(p)

	def has_point(self, x, y):
		return (y ** 2) % self.p == (x ** 3 + self.a * x + self.b) % self.p

	def __str__(self):
		return 'y^2 = x^3 + {}x + {}'.format(self.a, self.b)

	def isogenie(self, kernel):
		"""Return the isogenie """
		pass


class ECurvePoint:
	def __init__(self, x, y, curve):

		if isinstance(curve, ECurve):
			self.p = curve.p
			self.curve = curve
		else:
			raise TypeError("curve shall be a ECurve object and not " + format(type(curve)))
		self.x = utils.is_int(x) % curve.p
		self.y = utils.is_int(y) % curve.p

	def is_point_of(self, curve):
		return self.y ** 2 == self.x ** 3 + curve.a * self.x + curve.b * self.y

	def __getitem__(self, index):
		return [self.x, self.y][index]

	def __eq__(self, Q):
		return (self.curve, self.x, self.y) == (Q.curve, Q.x, Q.y)

	def __neg__(self):
		return ECurvePoint(self.x, -self.y, self.curve, )

	def __add__(self, Q):
		"""Add two points together.

		We need to take care of special cases:
		 * Q is the infinity point (0)
		 * P == Q
		 * The line crossing P and Q is vertical.

		"""
		assert self.curve == Q.curve

		# 0 + P = P
		if isinstance(Q, ECurveInf):
			return self
		if isinstance(self, ECurveInf):
			return Q

		xp, yp, xq, yq = self.x, self.y, Q.x, Q.y
		m = None

		# P == Q
		if self == Q:
			if self.y == 0:
				R = ECurveInf(self.curve)
			else:
				m = ((3 * xp * xp + self.curve.a) * utils.mod_inverse(2 * yp, self.curve.p)) % self.curve.p

		# Vertical line
		elif xp == xq:
			R = ECurveInf(self.curve)

		# Common case
		else:
			m = ((yq - yp) * utils.mod_inverse(xq - xp, self.curve.p)) % self.curve.p

		if m is not None:
			xr = (m ** 2 - xp - xq) % self.curve.p
			yr = (m * (xp - xr) - yp) % self.curve.p
			R = ECurvePoint(xr, yr, self.curve)

		return R

	def __mul__(self, n):
		assert isinstance(n, int)
		assert n > 0

		n = n % self.curve.p

		if n == 0:
			return ECurveInf(self.curve)

		else:
			Q = self
			R = ECurveInf(self.curve)

			i = 1
			while i <= n:
				if n & i == i:
					R = R + Q

				Q = Q + Q

				i = i << 1

		return R

	def __rmul__(self, n):
		return self * n

	def __str__(self):
		if isinstance(self, ECurveInf):
			return "curve :" + format(self.curve) + " InfPoint"
		return "curve :" + format(self.curve) + "   x : " + format(self.x) + "    y : " + format(self.y)

	def generate_subgroup(self):
		point_list = []
		point = self
		scalar = 2
		while not(point in point_list):
			point_list.append(point)
			point = scalar*self
			scalar += 1
		return point_list

class ECurveInf(ECurvePoint):
	"""The custom infinity point."""

	def __init__(self, curve):
		self.curve = curve

	def __eq__(self, Q):
		return isinstance(Q, ECurveInf)

	def __neg__(self):
		"""-0 = 0"""
		return self

3

curve = ECurve(a=0, b=1, p=23)
point = ECurvePoint(x=2, y=3, curve=curve)
point2 = ECurvePoint(x=2, y=10, curve=curve)

list_point = point.generate_subgroup()
for point in list_point:
	print(point)
	if not isinstance(point, ECurveInf):
		print(point.curve.has_point(point.x, point.y))
	else:
		print(True)
#
# point3 = point + point
# print(point3)
