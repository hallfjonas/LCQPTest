function[modpath, datpath, corrected] = GetPaths(name)

basedir = 'MacMPEC/MacMPECMatlab/data/';
corrected = name;

modpath = [basedir, corrected, '.mod'];
datpath = [basedir, corrected, '.dat'];

if (isfile(modpath))
    return
end

% Try dots
corrected = replace(name, '_', '.');
modpath = [basedir, corrected, '.mod'];
datpath = [basedir, corrected, '.dat'];
if (isfile(modpath))
    return
end

% Try hyphens
corrected = replace(name, '_', '-');
modpath = [basedir, corrected, '.mod'];
datpath = [basedir, corrected, '.dat'];
if (isfile(modpath))
    return
end

% Try flp4
if (startsWith(corrected, 'flp4'))
    modpath = [basedir, 'flp4.mod'];
    datpath = [basedir, corrected, '.dat'];
    
    % Try flp4s
    if (regexp(name, "flp4_[0-9]_s"))
        corrected = ['flp4-s-', name(6)];
        datpath = [basedir, corrected, '.dat'];
    end
    
    return;
end    

% Try liswet
if (startsWith(corrected, 'liswet1'))
    modpath = [basedir, 'liswet1-inv.mod'];
    datpath = [basedir, corrected, '.dat'];
    
    return;
end    

% Try nash
if (startsWith(corrected, 'nash1'))
    modpath = [basedir, 'nash1.mod'];
    datpath = [basedir, corrected, '.dat'];
    
    return;
end    

% Try portfolio
if (startsWith(corrected, 'portfl'))
    modpath = [basedir, 'portfl-i.mod'];
    datpath = [basedir, corrected, '.dat'];
    
    return;
end    

error("Could not find file adjustment %s", corrected);

end
