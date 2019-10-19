def handle_arxiv(url,mode='abs'):
    '''
    url : String : 
    eg: https://arxiv.org/pdf/1902.03468.pdf 
    mode:
    - abs --> Returns Abstact URL
    - pdf --> Returns Direct Pdf URL
    
    '''
    if not isinstance(url,str):
        print("Url must be a String ")
        raise TypeError
    if mode not in ['abs','pdf']:
        print('Invalid Mode')
        return None
    if mode=='abs':
        return "https://arxiv.org/abs/"+url.split('/')[-1].strip('.pdf')
    elif mode=='pdf':
         return "https://arxiv.org/pdf/"+url.split('/')[-1].strip('.pdf')+'.pdf'
