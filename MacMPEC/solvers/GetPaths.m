function[modpath, datpath] = GetPaths(name)

corrected = name;

modpath = ['data/', corrected, '.mod'];
datpath = ['data/', corrected, '.dat'];

if (isfile(modpath))
    return
end

% Try dots
corrected = replace(name, '_', '.');
modpath = ['data/', corrected, '.mod'];
datpath = ['data/', corrected, '.dat'];
if (isfile(modpath))
    return
end

% Try hyphens
corrected = replace(name, '_', '-');
modpath = ['data/', corrected, '.mod'];
datpath = ['data/', corrected, '.dat'];
if (isfile(modpath))
    return
end

% Try flp4
if (startsWith(corrected, 'flp4'))
    modpath = ['data/flp4.mod'];
    datpath = ['data/', corrected, '.dat'];
    
    % Try flp4s
    if (regexp(name, "flp4_[0-9]_s"))
        datpath = ['data/flp4-s-', name(6), '.dat'];
    end
    
    return;
end    

% Try liswet
if (startsWith(corrected, 'liswet1'))
    modpath = ['data/liswet1-inv.mod'];
    datpath = ['data/', corrected, '.dat'];
    
    return;
end    

% Try nash
if (startsWith(corrected, 'nash1'))
    modpath = ['data/nash1.mod'];
    datpath = ['data/', corrected, '.dat'];
    
    return;
end    

% Try portfolio
if (startsWith(corrected, 'portfl'))
    modpath = ['data/portfl-i.mod'];
    datpath = ['data/', corrected, '.dat'];
    
    return;
end    

error("Could not find file adjustment %s", corrected);

end
