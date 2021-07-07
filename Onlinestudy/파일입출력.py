#!/usr/bin/env python
# coding: utf-8

# In[10]:


fr = open('./12-1. hello.txt', 'r') 


# In[11]:


for line in fr:
    print(line)


# In[12]:


fr.close()


# #### r : 읽기모드 open  
# w : 쓰기모드 open / 동일 존재시 overwrite  
# x : 쓰기모드 open / 동일 존재시 error  
# a : 쓰기모드 open / 동일 존재시 append  
# '+' : 읽기,쓰기모드 open

# In[13]:


with open('./12-1. hello.txt', 'r') as fr:
    for line in fr:
        print(line)


# ## 파일 출력

# In[29]:


fw = open('./hello_write.txt','w')


# In[28]:


fw.write('Hello World Python!!!\n')


# In[24]:


fw.write('Welcome to Python World!!!')


# In[30]:


fw.write('Welcome to Python World!!!')
fw.close()


# In[31]:


with open('./hello_write.txt', 'w') as fw:
    fw.write('Hello World Python!!!\n')
    fw.write('Welcome to Python World!!!\n')


# In[33]:


with open('./hello_write.txt', 'a') as fw:
    fw.write('New line append!!!')


# ## 파일 시스템

# In[37]:


import os
file_list = os.listdir('.')


# In[38]:


file_ipynb = [ f for f in file_list if f.endswith('.ipynb')]


# In[39]:


os.getcwd()


# In[40]:


os.mkdir('test')  # 디렉토리 생성


# In[41]:


os.path.join('.', 'test') # 파일구분자로 연결


# In[43]:


os.path.abspath('hello_write.txt') # 절대경로 반환


# In[44]:


os.path.isfile('hello_write.txt')


# In[45]:


os.path.isdir('hello_write.txt')


# In[46]:


os.path.isfile('test')


# In[47]:


os.path.isdir('test')


# In[48]:


os.path.split(os.path.abspath('hello_write.txt'))  # 디렉토리명과 파일명의 분리


# In[ ]:


os.path.splitext('hello_write.txt')  # 파일명과 확장자의 분리

