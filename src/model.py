#####################################################
import numpy as np
# This file is created automatically
def Model(Y,t,pars):
    # Parameters
    a_a_c = pars[0]
    a_b_a = pars[1]
    a_c_b = pars[2]
    alpha_a = pars[3]
    alpha_b = pars[4]
    alpha_c = pars[5]
    k_a = pars[6]
    k_b = pars[7]
    k_c = pars[8]
    l_p_a = pars[9]
    l_p_b = pars[10]
    l_p_c = pars[11]
    l_x_a = pars[12]
    l_x_b = pars[13]
    l_x_c = pars[14]
    m_a = pars[15]
    m_b = pars[16]
    m_c = pars[17]
    n_a = pars[18]
    n_b = pars[19]
    n_c = pars[20]
    r_a = pars[21]
    r_b = pars[22]
    r_c = pars[23]
    # Variables
    x_a = Y[0]
    p_a = Y[1]
    x_c = Y[2]
    p_c = Y[3]
    x_b = Y[4]
    p_b = Y[5]
    dx_a = m_a*(( alpha_a + a_a_c*(p_c/k_c)**n_c )/( 1 +(p_c/k_c)**n_c ))-l_x_a*x_a
    dp_a = r_a*x_a- l_p_a*p_a
    dx_c = m_c*(( alpha_c + a_c_b*(p_b/k_b)**n_b )/( 1 +(p_b/k_b)**n_b ))-l_x_c*x_c
    dp_c = r_c*x_c- l_p_c*p_c
    dx_b = m_b*(( alpha_b + a_b_a*(p_a/k_a)**n_a )/( 1 +(p_a/k_a)**n_a ))-l_x_b*x_b
    dp_b = r_b*x_b- l_p_b*p_b
    dY = np.array([dx_a,dp_a,dx_c,dp_c,dx_b,dp_b,])
    return(dY)
#####################################################