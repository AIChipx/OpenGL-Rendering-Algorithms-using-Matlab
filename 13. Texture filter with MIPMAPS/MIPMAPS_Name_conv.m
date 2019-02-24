function [ string ] = MIPMAPS_Name_conv( index )
% convert input number to its corresponding string

switch index
    case 0
        string = 'Mip_level_0';
    case 1
        string = 'Mip_level_1';
    case 2
        string = 'Mip_level_2';
    case 3
        string = 'Mip_level_3';
    case 4
        string = 'Mip_level_4';
    case 5
        string = 'Mip_level_5';
    case 6
        string = 'Mip_level_6';
    case 7
        string = 'Mip_level_7';
    case 8
        string = 'Mip_level_8';
    case 9
        string = 'Mip_level_9';
    case 10
        string = 'Mip_level_10';
    case 11
        string = 'Mip_level_11';
    case 12
        string = 'Mip_level_12';
    case 13
        string = 'Mip_level_13';
    case 14
        string = 'Mip_level_14';
    case 15
        string = 'Mip_level_15';
    otherwise
        error('Maximun Mipmap level is: 15');
end
end

