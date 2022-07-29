#!/usr/bin/env sage

p = 0xa745e606518ab2a7a4c4cbd0243ff
x1 = 1
x2 = 10246385595908412093322394614482812
x3 = 39363994084598900187252501570838981
x5 = 32685866221368843545964725685301333
x8 = 9181400195848862839133315651176794

# Recover a, b by using x-only coordinate arithmitic
R.<a, b> = PolynomialRing(GF(p))


def add(x1, x2, x3):
    n = 2*(x1 + x2) * (x1*x2 + a) + 4*b
    d = (x1 - x2)**2
    return (n / d) - x3


Id = Ideal(add(x3, x2, x1) - x5, add(x5, x3, x2) - x8)
v = Id.variety()
a = v[0]['a']
b = v[0]['b']
E = EllipticCurve(GF(p), [a, b])


def SmartAttack(P, Q, p):
    E = P.curve()
    Eqp = EllipticCurve(Qp(p, 2), [ZZ(t) + randint(0, p)*p for t in E.a_invariants()])

    P_Qps = Eqp.lift_x(ZZ(P.xy()[0]), all=True)
    for P_Qp in P_Qps:
        if GF(p)(P_Qp.xy()[1]) == P.xy()[1]:
            break

    Q_Qps = Eqp.lift_x(ZZ(Q.xy()[0]), all=True)
    for Q_Qp in Q_Qps:
        if GF(p)(Q_Qp.xy()[1]) == Q.xy()[1]:
            break

    p_times_P = p*P_Qp
    p_times_Q = p*Q_Qp

    x_P, y_P = p_times_P.xy()
    x_Q, y_Q = p_times_Q.xy()

    phi_P = -(x_P/y_P)
    phi_Q = -(x_Q/y_Q)
    k = phi_Q/phi_P
    return ZZ(k)


P = E.lift_x(1)
Q = E.lift_x(1337)

x = SmartAttack(P, Q, p)
print(x)
